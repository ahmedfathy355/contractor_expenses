import 'package:contractor_expenses/Pages/login.dart';
import 'package:flutter/material.dart';
import 'Models/route_argument.dart';
import 'Home.dart';
import 'Pages/splash_screen.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/Splash':
        return MaterialPageRoute(builder: (_) => Splash());
      // case '/SignUp':
      //   return MaterialPageRoute(builder: (_) => SignUpWidget());
      // case '/MobileVerification':
      //   return MaterialPageRoute(builder: (_) => SignUpWidget());
      // case '/MobileVerification2':
      //   return MaterialPageRoute(builder: (_) => MobileVerification2());
      case '/Login':
        return MaterialPageRoute(builder: (_) => Login());
      // case '/Profile':
      //   return MaterialPageRoute(builder: (_) => ProfileWidget());
      // case '/ForgetPassword':
      //   return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      // case '/Pages':
      //   return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      // case '/Favorites':
      //   return MaterialPageRoute(builder: (_) => FavoritesWidget());
      // case '/Chat':
      //   return MaterialPageRoute(builder: (_) => ChatWidget(routeArgument: args as RouteArgument));
      // case '/Details':
      //   return MaterialPageRoute(builder: (_) => DetailsWidget(currentTab: args));
      // case '/Menu':
      //   return MaterialPageRoute(builder: (_) => MenuWidget(routeArgument: args as RouteArgument));
      // case '/Product':
      //   return MaterialPageRoute(builder: (_) => ProductWidget(routeArgument: args as RouteArgument));
      // case '/Category':
      //   return MaterialPageRoute(builder: (_) => CategoryWidget(routeArgument: args as RouteArgument));
      // case '/Cart':
      //   return MaterialPageRoute(builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      // case '/Tracking':
      //   return MaterialPageRoute(builder: (_) => TrackingWidget(routeArgument: args as RouteArgument));
      // case '/Reviews':
      //   return MaterialPageRoute(builder: (_) => ReviewsWidget(routeArgument: args as RouteArgument));
      // case '/PaymentMethod':
      //   return MaterialPageRoute(builder: (_) => PaymentMethodsWidget());
      // case '/DeliveryAddresses':
      //   return MaterialPageRoute(builder: (_) => DeliveryAddressesWidget());
      // case '/DeliveryPickup':
      //   return MaterialPageRoute(builder: (_) => DeliveryPickupWidget(routeArgument: args as RouteArgument));
      // case '/Checkout':
      //   return MaterialPageRoute(builder: (_) => CheckoutWidget());
      // case '/CashOnDelivery':
      //   return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: RouteArgument(param: 'Cash on Delivery')));
      // case '/PayOnPickup':
      //   return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: RouteArgument(param: 'Pay on Pickup')));
      // case '/PayPal':
      //   return MaterialPageRoute(builder: (_) => PayPalPaymentWidget(routeArgument: args as RouteArgument));
      // case '/RazorPay':
      //   return MaterialPageRoute(builder: (_) => RazorPayPaymentWidget(routeArgument: args as RouteArgument));
      // case '/OrderSuccess':
      //   return MaterialPageRoute(builder: (_) => OrderSuccessWidget(routeArgument: args as RouteArgument));
      // case '/Languages':
      //   return MaterialPageRoute(builder: (_) => LanguagesWidget());
      // case '/Help':
      //   return MaterialPageRoute(builder: (_) => HelpWidget());
      // case '/Settings':
      //   return MaterialPageRoute(builder: (_) => SettingsWidget());
      // default:
      //   // If there is no such named route in the switch statement, e.g. /third
      //   return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
