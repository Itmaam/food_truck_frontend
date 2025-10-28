// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Food Truck Finder`
  String get appTitle {
    return Intl.message(
      'Food Truck Finder',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: 'Forgot password link text',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: 'Email field hint text',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password field hint text',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verifyOtp {
    return Intl.message(
      'Verify OTP',
      name: 'verifyOtp',
      desc: '',
      args: [],
    );
  }

  /// `OTP Code`
  String get otp {
    return Intl.message(
      'OTP Code',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsconditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsconditions',
      desc: '',
      args: [],
    );
  }

  /// `By using the app, you agree to our `
  String get I_aggree_to {
    return Intl.message(
      'By using the app, you agree to our ',
      name: 'I_aggree_to',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(
      ' and ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Change Theme to {themeName}`
  String changeThemeMsg(String themeName) {
    return Intl.message(
      'Change Theme to $themeName',
      name: 'changeThemeMsg',
      desc: 'Change Theme to {themeName}',
      args: [themeName],
    );
  }

  /// `signin with Apple`
  String get signinWithApple {
    return Intl.message(
      'signin with Apple',
      name: 'signinWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verifyOtpTitle {
    return Intl.message(
      'Verify OTP',
      name: 'verifyOtpTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter the 6-digit OTP sent to {email}`
  String otpSentMessage(Object email) {
    return Intl.message(
      'Enter the 6-digit OTP sent to $email',
      name: 'otpSentMessage',
      desc: '',
      args: [email],
    );
  }

  /// `OTP Code`
  String get otpCodeHint {
    return Intl.message(
      'OTP Code',
      name: 'otpCodeHint',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verifyOtpButton {
    return Intl.message(
      'Verify OTP',
      name: 'verifyOtpButton',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message(
      'Cancel',
      name: 'cancelButton',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP verification response`
  String get invalidOtpResponse {
    return Intl.message(
      'Invalid OTP verification response',
      name: 'invalidOtpResponse',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again.`
  String get genericError {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'genericError',
      desc: '',
      args: [],
    );
  }

  /// `Set New Password`
  String get setNewPasswordTitle {
    return Intl.message(
      'Set New Password',
      name: 'setNewPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPasswordHint {
    return Intl.message(
      'New Password',
      name: 'newPasswordHint',
      desc: 'Hint text for new password input field',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPasswordHint {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPasswordHint',
      desc: 'Hint text for confirm password input field',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordMismatchError {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordMismatchError',
      desc: 'Error message when passwords don\'t match',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPasswordButton {
    return Intl.message(
      'Reset Password',
      name: 'resetPasswordButton',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Please try again.`
  String get genericErrorMessage {
    return Intl.message(
      'An error occurred. Please try again.',
      name: 'genericErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Log in with Google`
  String get loginWithGoogle {
    return Intl.message(
      'Log in with Google',
      name: 'loginWithGoogle',
      desc: 'Google login button text',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Continue as a guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as a guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `Already have a account?`
  String get haveAccount {
    return Intl.message(
      'Already have a account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get activityDetailsTitle {
    return Intl.message(
      'Details',
      name: 'activityDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Working Hours: {openingTime} - {closingTime}`
  String workingHours(Object openingTime, Object closingTime) {
    return Intl.message(
      'Working Hours: $openingTime - $closingTime',
      name: 'workingHours',
      desc: 'Text showing food truck working hours',
      args: [openingTime, closingTime],
    );
  }

  /// `Information`
  String get addressTab {
    return Intl.message(
      'Information',
      name: 'addressTab',
      desc: '',
      args: [],
    );
  }

  /// `Food Menu`
  String get foodMenuTab {
    return Intl.message(
      'Food Menu',
      name: 'foodMenuTab',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviewsTab {
    return Intl.message(
      'Reviews',
      name: 'reviewsTab',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load food truck: {error}`
  String failedToLoadFoodTruck(Object error) {
    return Intl.message(
      'Failed to load food truck: $error',
      name: 'failedToLoadFoodTruck',
      desc: 'Error message when food truck fails to load',
      args: [error],
    );
  }

  /// `Location`
  String get locationTitle {
    return Intl.message(
      'Location',
      name: 'locationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled.`
  String get locationServicesDisabled {
    return Intl.message(
      'Location services are disabled.',
      name: 'locationServicesDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are denied`
  String get locationPermissionsDenied {
    return Intl.message(
      'Location permissions are denied',
      name: 'locationPermissionsDenied',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are permanently denied, we cannot request permissions.`
  String get locationPermissionsPermanentlyDenied {
    return Intl.message(
      'Location permissions are permanently denied, we cannot request permissions.',
      name: 'locationPermissionsPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Could not get location: {error}`
  String couldNotGetLocation(Object error) {
    return Intl.message(
      'Could not get location: $error',
      name: 'couldNotGetLocation',
      desc: 'Error message when location cannot be obtained',
      args: [error],
    );
  }

  /// `Current Location`
  String get currentLocationButton {
    return Intl.message(
      'Current Location',
      name: 'currentLocationButton',
      desc: '',
      args: [],
    );
  }

  /// `Menu Items`
  String get menuItemsTitle {
    return Intl.message(
      'Menu Items',
      name: 'menuItemsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Item Name*`
  String get itemNameRequired {
    return Intl.message(
      'Item Name*',
      name: 'itemNameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get itemDescription {
    return Intl.message(
      'Description',
      name: 'itemDescription',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get nameRequiredError {
    return Intl.message(
      'Name is required',
      name: 'nameRequiredError',
      desc: '',
      args: [],
    );
  }

  /// `Add Image`
  String get addImageButton {
    return Intl.message(
      'Add Image',
      name: 'addImageButton',
      desc: '',
      args: [],
    );
  }

  /// `Add Menu Item`
  String get addMenuItemButton {
    return Intl.message(
      'Add Menu Item',
      name: 'addMenuItemButton',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photosTitle {
    return Intl.message(
      'Photos',
      name: 'photosTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete Image`
  String get deleteImageDialogTitle {
    return Intl.message(
      'Delete Image',
      name: 'deleteImageDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this image?`
  String get deleteImageDialogContent {
    return Intl.message(
      'Are you sure you want to delete this image?',
      name: 'deleteImageDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteButton {
    return Intl.message(
      'Delete',
      name: 'deleteButton',
      desc: '',
      args: [],
    );
  }

  /// `Add Photos`
  String get addPhotosButton {
    return Intl.message(
      'Add Photos',
      name: 'addPhotosButton',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load food truck!`
  String get failedLoadFoodTruck {
    return Intl.message(
      'Failed to load food truck!',
      name: 'failedLoadFoodTruck',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Working Hours: {hour}`
  String workingHour(Object hour) {
    return Intl.message(
      'Working Hours: $hour',
      name: 'workingHour',
      desc: '',
      args: [hour],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Food Menu`
  String get foodMenu {
    return Intl.message(
      'Food Menu',
      name: 'foodMenu',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get review {
    return Intl.message(
      'Reviews',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Map Location`
  String get mapLocation {
    return Intl.message(
      'Map Location',
      name: 'mapLocation',
      desc: '',
      args: [],
    );
  }

  /// `Tap for directions`
  String get tapForLocation {
    return Intl.message(
      'Tap for directions',
      name: 'tapForLocation',
      desc: '',
      args: [],
    );
  }

  /// `Share Location`
  String get shareLocation {
    return Intl.message(
      'Share Location',
      name: 'shareLocation',
      desc: '',
      args: [],
    );
  }

  /// `Get Directions`
  String get getDirection {
    return Intl.message(
      'Get Directions',
      name: 'getDirection',
      desc: '',
      args: [],
    );
  }

  /// `Write a Review`
  String get writeReview {
    return Intl.message(
      'Write a Review',
      name: 'writeReview',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get rating {
    return Intl.message(
      'Rating',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get required {
    return Intl.message(
      'Required',
      name: 'required',
      desc: '',
      args: [],
    );
  }

  /// `Please add at least one photo`
  String get atleastOnePhoto {
    return Intl.message(
      'Please add at least one photo',
      name: 'atleastOnePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Add Food Truck`
  String get addTruck {
    return Intl.message(
      'Add Food Truck',
      name: 'addTruck',
      desc: '',
      args: [],
    );
  }

  /// `Add Food Truck`
  String get editTruck {
    return Intl.message(
      'Add Food Truck',
      name: 'editTruck',
      desc: '',
      args: [],
    );
  }

  /// `Store Details`
  String get truckDetails {
    return Intl.message(
      'Store Details',
      name: 'truckDetails',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get category {
    return Intl.message(
      'Categories',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Subcategories`
  String get subCategories {
    return Intl.message(
      'Subcategories',
      name: 'subCategories',
      desc: '',
      args: [],
    );
  }

  /// `Opening Time`
  String get openingTime {
    return Intl.message(
      'Opening Time',
      name: 'openingTime',
      desc: '',
      args: [],
    );
  }

  /// `Closing Time`
  String get closingTime {
    return Intl.message(
      'Closing Time',
      name: 'closingTime',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contactInfo {
    return Intl.message(
      'Contact Information',
      name: 'contactInfo',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get website {
    return Intl.message(
      'Website',
      name: 'website',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Click to view details`
  String get clickToDetails {
    return Intl.message(
      'Click to view details',
      name: 'clickToDetails',
      desc: '',
      args: [],
    );
  }

  /// `We’d love to hear from you!`
  String get contactUsTitle {
    return Intl.message(
      'We’d love to hear from you!',
      name: 'contactUsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Message sent!`
  String get messageSent {
    return Intl.message(
      'Message sent!',
      name: 'messageSent',
      desc: '',
      args: [],
    );
  }

  /// `No favorites yet`
  String get noFavorites {
    return Intl.message(
      'No favorites yet',
      name: 'noFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Mark all as read`
  String get markAllRead {
    return Intl.message(
      'Mark all as read',
      name: 'markAllRead',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet`
  String get noNotifications {
    return Intl.message(
      'No notifications yet',
      name: 'noNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Log in with Google`
  String get loginGoogle {
    return Intl.message(
      'Log in with Google',
      name: 'loginGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Search food trucks`
  String get search {
    return Intl.message(
      'Search food trucks',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Your Store`
  String get yourFoodTruck {
    return Intl.message(
      'Your Store',
      name: 'yourFoodTruck',
      desc: '',
      args: [],
    );
  }

  /// `Delete Food Truck`
  String get deleteFoodTruck {
    return Intl.message(
      'Delete Food Truck',
      name: 'deleteFoodTruck',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this food truck?`
  String get areYouSureDeleteFoodTruck {
    return Intl.message(
      'Are you sure you want to delete this food truck?',
      name: 'areYouSureDeleteFoodTruck',
      desc: '',
      args: [],
    );
  }

  /// `Select Time`
  String get selectTime {
    return Intl.message(
      'Select Time',
      name: 'selectTime',
      desc: '',
      args: [],
    );
  }

  /// `Off Day`
  String get offDay {
    return Intl.message(
      'Off Day',
      name: 'offDay',
      desc: '',
      args: [],
    );
  }

  /// `Open Now`
  String get openNow {
    return Intl.message(
      'Open Now',
      name: 'openNow',
      desc: '',
      args: [],
    );
  }

  /// `Closed Now`
  String get closedNow {
    return Intl.message(
      'Closed Now',
      name: 'closedNow',
      desc: '',
      args: [],
    );
  }

  /// `Phone number copied to clipboard`
  String get phoneCopied {
    return Intl.message(
      'Phone number copied to clipboard',
      name: 'phoneCopied',
      desc: '',
      args: [],
    );
  }

  /// `For any inquiries, please contact us at`
  String get contactUsFooter {
    return Intl.message(
      'For any inquiries, please contact us at',
      name: 'contactUsFooter',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant Type`
  String get restaurant_type {
    return Intl.message(
      'Restaurant Type',
      name: 'restaurant_type',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filters`
  String get applyFilters {
    return Intl.message(
      'Apply Filters',
      name: 'applyFilters',
      desc: '',
      args: [],
    );
  }

  /// `Clear Filters`
  String get clearFilters {
    return Intl.message(
      'Clear Filters',
      name: 'clearFilters',
      desc: '',
      args: [],
    );
  }

  /// `Filter by Type`
  String get filterByType {
    return Intl.message(
      'Filter by Type',
      name: 'filterByType',
      desc: '',
      args: [],
    );
  }

  /// `No item found`
  String get noFoodTrucksFound {
    return Intl.message(
      'No item found',
      name: 'noFoodTrucksFound',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.`
  String get deleteAccountMessage {
    return Intl.message(
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
      name: 'deleteAccountMessage',
      desc: '',
      args: [],
    );
  }

  /// `Time Conflict`
  String get timeConflict {
    return Intl.message(
      'Time Conflict',
      name: 'timeConflict',
      desc: '',
      args: [],
    );
  }

  /// `The opening time you selected is after the closing time. What would you like to do?`
  String get openAfterCloseErrorMsg {
    return Intl.message(
      'The opening time you selected is after the closing time. What would you like to do?',
      name: 'openAfterCloseErrorMsg',
      desc: '',
      args: [],
    );
  }

  /// `The closing time you selected is before the opening time. What would you like to do?`
  String get closeBeforeOpenErrorMsg {
    return Intl.message(
      'The closing time you selected is before the opening time. What would you like to do?',
      name: 'closeBeforeOpenErrorMsg',
      desc: '',
      args: [],
    );
  }

  /// `Apply to all days`
  String get applyToAllDays {
    return Intl.message(
      'Apply to all days',
      name: 'applyToAllDays',
      desc: '',
      args: [],
    );
  }

  /// `Select Location`
  String get selectLocation {
    return Intl.message(
      'Select Location',
      name: 'selectLocation',
      desc: '',
      args: [],
    );
  }

  /// `FullScreen`
  String get fullScreen {
    return Intl.message(
      'FullScreen',
      name: 'fullScreen',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load`
  String get failedToLoad {
    return Intl.message(
      'Failed to load',
      name: 'failedToLoad',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get signinwithapple {
    return Intl.message(
      'Sign in with Apple',
      name: 'signinwithapple',
      desc: '',
      args: [],
    );
  }

  /// `Add Review`
  String get addReview {
    return Intl.message(
      'Add Review',
      name: 'addReview',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this review?`
  String get areYouSureYouWantToDeleteThisReview {
    return Intl.message(
      'Are you sure you want to delete this review?',
      name: 'areYouSureYouWantToDeleteThisReview',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Delete`
  String get confirmDelete {
    return Intl.message(
      'Confirm Delete',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Review deleted`
  String get reviewDeleted {
    return Intl.message(
      'Review deleted',
      name: 'reviewDeleted',
      desc: '',
      args: [],
    );
  }

  /// `No reviews yet`
  String get noReviews {
    return Intl.message(
      'No reviews yet',
      name: 'noReviews',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to exit the app?`
  String get areYouSureToExit {
    return Intl.message(
      'Are you sure you want to exit the app?',
      name: 'areYouSureToExit',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Select Image Source`
  String get selectImageSource {
    return Intl.message(
      'Select Image Source',
      name: 'selectImageSource',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Failed to pick image: {error}`
  String failedToPickImage(Object error) {
    return Intl.message(
      'Failed to pick image: $error',
      name: 'failedToPickImage',
      desc: 'Error message when image picking fails',
      args: [error],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Failed to upload image: {error}`
  String failedToUploadImage(Object error) {
    return Intl.message(
      'Failed to upload image: $error',
      name: 'failedToUploadImage',
      desc: 'Error message when image upload fails',
      args: [error],
    );
  }

  /// `Failed to delete image: {error}`
  String failedToDeleteImage(Object error) {
    return Intl.message(
      'Failed to delete image: $error',
      name: 'failedToDeleteImage',
      desc: 'Error message when image deletion fails',
      args: [error],
    );
  }

  /// `Failed to add menu item: {error}`
  String failedToAddMenuItem(Object error) {
    return Intl.message(
      'Failed to add menu item: $error',
      name: 'failedToAddMenuItem',
      desc: 'Error message when adding menu item fails',
      args: [error],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
