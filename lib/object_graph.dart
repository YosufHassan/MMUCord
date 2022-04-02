//@dart=2.9

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:mmucord/cache/local_cache.dart';
import 'package:mmucord/data/dataSources/data_source_contract.dart';
import 'package:mmucord/data/dataSources/data_source_impl.dart';
import 'package:mmucord/data/dataSources/database_factory.dart';
import 'package:mmucord/data/services/analyticsService.dart';
import 'package:mmucord/data/services/image_upload.dart';
import 'package:mmucord/states_management/boarding/boarding_cubit.dart';
import 'package:mmucord/states_management/boarding/profile_image_cubit.dart';
import 'package:mmucord/states_management/chat_screen/chat_screen_cubit.dart';
import 'package:mmucord/states_management/message/message_bloc.dart';
import 'package:mmucord/states_management/profile_screen/analytics_cubit.dart';
import 'package:mmucord/states_management/receipt/receipt_bloc.dart';
import 'package:mmucord/states_management/typing/typing_notification_bloc.dart';
import 'package:mmucord/states_management/users_page/chats_cubit.dart';
import 'package:mmucord/states_management/users_page/users_page_cubit.dart';
import 'package:mmucord/user_interface/screens/boarding.dart';
import 'package:mmucord/user_interface/screens/boarding_router.dart';
import 'package:mmucord/user_interface/screens/chat_screen.dart';
import 'package:mmucord/user_interface/screens/profile_screen.dart';
import 'package:mmucord/user_interface/screens/profile_screen_router.dart';
import 'package:mmucord/user_interface/screens/users_page.dart';
import 'package:mmucord/user_interface/screens/users_page_router.dart';
import 'package:mmucord/view_models/analytics_view_model.dart';
import 'package:mmucord/view_models/chat_view_model.dart';
import 'package:mmucord/view_models/chats_view_model.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class ObjectGraph {
  static Rethinkdb _r;
    static Connection _connection;
    static IUserService _userService;
    static Database _db;
    static IMessageService _messageService;
    static IDatasource _datasource;
    static ILocalCache _localCache;
    static MessageBloc _messageBloc;
    static ITypingNotification _typingNotification;
    static TypingNotificationBloc _typingNotificationBloc;
    static ChatsCubit _chatsCubit;

    static bootstrap() async {

      _r = Rethinkdb(); // create the RethinkDB instance
      _connection = await _r.connect(host: '192.168.1.5', port: 28015); // connect on 10.0.2.2 because the emulator uses this IP for loopback address


      _userService = UserService(_r, _connection); // instantiate the user service
      _messageService = MessageService(_r, _connection); // instantiate the Message service
      _typingNotification = TypingNotification(_r, _connection, _userService); // instantiate the Typing notifier service
      
      

      _db = await LocalDatabaseFactory().createDatabase(); // create the local sqlite database
      _datasource = LocalSqflite(_db); // instantiate the local datasource
      final sp = await SharedPreferences.getInstance(); // instantiate the shared prefrences object
      _localCache = LocalCache(sp); // instantiate the shared prefrences object
      

      
      _messageBloc = MessageBloc(_messageService); // Instantiate the message bloc
      _typingNotificationBloc = TypingNotificationBloc(_typingNotification); // instantiate the Typing notification bloc



      final viewModel = ChatsViewModel(_datasource, _userService); // instantiate the view model
      _chatsCubit = ChatsCubit(viewModel); // instantiate the chats cubit
    }

    static Widget start() {

      /* 
        Start() Widget

        A widget that checks if there is a user already logged in to the application and act acordingly

        The start method scans the phones local storage to find if a user object is stored, if a user object

        is found it redirects to the messages screen, otherwise it redirects to the boarding page
      */

      final user = _localCache.fetch('USER'); // fetch user from the local storage, the user is stored under the key 'USER'
      return user.isEmpty
          ? composeBoardingUI()
          : composeHomeUI(User.fromJson(user));
    }

    static Widget composeBoardingUI() {

      /* 
        composeBoardingUI() Method

        A method that is responsible for bootstraping and instantiating all the dependences that is needed by the boarding screen

        It instantiates the image uploader service used to upload the profile image to the server

        It intiates all the cubits and configure all the bloc providers that manage the states of boarding screen
      */

      ImageUploader imageUploader = ImageUploader('http://192.168.1.5:8000'); // Instantiate and configure the Image uploader
      
      // The routers and cubits needed for the boarding page

      boardingCubit onboardingCubit = boardingCubit(_userService, imageUploader, _localCache);
      ProfileImageCubit imageCubit = ProfileImageCubit();
      IOnboardingRouter router = OnboardingRouter(composeHomeUI);

      // The multibloc provider that provide access to all the blocs and cubits needed

      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => onboardingCubit),
          BlocProvider(create: (BuildContext context) => imageCubit),
        ],
        child: Boarding(router),
      );
    }

    /* 
        composeHomeUI(User me) Method

        A method that is responsible for bootstraping and instantiating all the dependences that make up the Home screen

        It intiates and configure all the cubits, bloc providers and routers that manage the states of Home screen
      */


    static Widget composeAnalayticsScreen(User me){

      SentCount sentCount = SentCount('http://192.168.1.5:8000', me.id);

      RecvCount recvCount = RecvCount('http://192.168.1.5:8000', me.id);

      Countunread countunread = Countunread('http://192.168.1.5:8000', me.id);

      Chatcount chatcount = Chatcount('http://192.168.1.5:8000', me.id);

      //ChatActive chatactive = ChatActive('http://192.168.1.5:8000', me.id);
      
      final analyticsViewModel = AnalyticsViewModel(_datasource);

      ProfileScreen analyticsScreen = ProfileScreen(me);

      analyticsCubit analyticscubit = analyticsCubit(me, sentCount, recvCount, chatcount, /*chatactive,*/countunread,analyticsViewModel);

      return BlocProvider(
        create: (BuildContext context) => analyticscubit,
        child: analyticsScreen,
      );

    }


    static Widget composeHomeUI(User me) {

      UsersPageCubit homeCubit = UsersPageCubit(_userService, _localCache);

      IHomeRouter router = HomeRouter(showMessageThread: composeMessageThreadUi); // Initiate the home router, that manages navigation in the home screen

      

      IProfileScreenRouter profileScreenRouter = ProfileScreenRouter(onSessionConnected:composeAnalayticsScreen);
      


      // The multibloc provider that provide access to all the blocs and cubits needed

      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => homeCubit),

          BlocProvider(create: (BuildContext context) => _messageBloc,),

          BlocProvider(create: (BuildContext context) => _typingNotificationBloc),

          BlocProvider(create: (BuildContext context) => _chatsCubit)
        ],

        child: usersPage(me, router,profileScreenRouter),
      );
    }

    /* 
        composeMessageThreadUi(User receiver, User me,{String chatId}) Method

        A method that is responsible for bootstraping and instantiating all the dependences that make up the Message screen

        It intiates and configure all the cubits, bloc providers that manage the states of Message screen
      */

    static Widget composeMessageThreadUi(User receiver, User me,{String chatId}) {
      
      ChatViewModel viewModel = ChatViewModel(_datasource);
      
      MessageThreadCubit messageThreadCubit = MessageThreadCubit(viewModel);

      IReceiptService receiptService = ReceiptService(_r, _connection);

      ReceiptBloc receiptBloc = ReceiptBloc(receiptService);
      IProfileScreenRouter profileScreenRouter = ProfileScreenRouter(onSessionConnected:composeAnalayticsScreen);

      // The multibloc provider that provide access to all the blocs and cubits needed

      return MultiBlocProvider(
          providers: [
            BlocProvider(create: (BuildContext context) => messageThreadCubit),

            BlocProvider(create: (BuildContext context) => receiptBloc)
          ],

          child: MessageThread(
              receiver, me, _messageBloc, _chatsCubit, _typingNotificationBloc, profileScreenRouter,chatId: chatId));
    }
  }