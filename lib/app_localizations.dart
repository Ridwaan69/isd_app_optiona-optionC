// lib/app_localizations.dart
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('fr', ''), // French
    Locale('es', ''), // Spanish
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Navigation
      'home': 'Home',
      'profile': 'Profile',
      'menu': 'Menu',
      'cart': 'Basket',
      'checkout': 'Checkout',

      // Auth
      'sign_in': 'Sign in to your account',
      'sign_up': 'Create your account',
      'email': 'Email',
      'password': 'Password',
      'staff_id': 'Staff ID',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'login': 'SIGN IN',
      'logout': 'Log out',
      'register': 'Sign Up',
      'cancel': 'CANCEL',
      'back': 'BACK',
      'admin_login': 'Admin Log in',
      'customer_login': 'Customer',
      'admin': 'Admin',
      'welcome': 'Welcome to SeaFeast',

      // Menu
      'starters': 'Starters',
      'main_courses': 'Main Courses',
      'drinks': 'Drinks',
      'desserts': 'Desserts',
      'quantity': 'Quantity:',
      'add_to_cart': 'Add to Cart',
      'allergens': 'Allergens',
      'browse_menu': 'Browse menu',

      // Cart
      'basket': 'Basket',
      'empty_basket': 'Your basket is empty',
      'empty_basket_desc': 'Browse the menu and add some items.',
      'subtotal': 'Sub-Total',
      'delivery_charge': 'Delivery Charge',
      'discount': 'Discount',
      'total': 'Total',
      'continue_shopping': 'Cancel',

      // Checkout
      'payment_option': 'Choose your payment option',
      'cash': 'Cash',
      'card': 'Mastercard',
      'no_card': 'No master card added',
      'add_card': 'You can add a mastercard and save it for later',
      'add_new': 'ADD NEW',
      'replace_card': 'REPLACE CARD',
      'card_saved': 'Card saved',
      'confirm_order': 'Confirm Order',
      'confirm_payment': 'Confirm payment',
      'order_confirmed': 'Order confirmed',
      'payment_successful': 'Payment Successful',
      'order_placed': 'Your order has been placed!',
      'confirm_order_btn': 'Confirm Order and Pay',

      // Profile
      'view_profile': 'View Profile',
      'name': 'Name',
      'date_of_birth': 'Date of Birth',
      'save_changes': 'Save changes',
      'profile_saved': 'Profile saved',

      // Home
      'reserve_table': 'Reserve Table',
      'view_profile_btn': 'View Profile',

      // Settings
      'language': 'Language',
      'select_language': 'Select Language',

      // Feedback (FR22)
      'feedback': 'Feedback',
      'give_feedback': 'Give Feedback',
      'rate_experience': 'Rate your experience',
      'comments': 'Comments',
      'comments_hint': 'Tell us about your experience...',
      'submit_feedback': 'Submit Feedback',
      'feedback_submitted': 'Thank you for your feedback!',

      // Booking (FR23, FR24)
      'book_table': 'Book a Table',
      'select_date': 'Select Date',
      'select_time': 'Select Time',
      'number_of_guests': 'Number of Guests',
      'available_slots': 'Available Slots',
      'book_now': 'Book Now',
      'booking_confirmed': 'Booking Confirmed!',
      'booking_details': 'Your table has been reserved.',
      'guests': 'guests',

      // Languages
      'english': 'English',
      'french': 'French',
      'spanish': 'Spanish',
    },
    'fr': {
      // Navigation
      'home': 'Accueil',
      'profile': 'Profil',
      'menu': 'Menu',
      'cart': 'Panier',
      'checkout': 'Paiement',

      // Auth
      'sign_in': 'Connectez-vous à votre compte',
      'sign_up': 'Créer votre compte',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'staff_id': 'ID du personnel',
      'first_name': 'Prénom',
      'last_name': 'Nom',
      'login': 'SE CONNECTER',
      'logout': 'Se déconnecter',
      'register': "S'inscrire",
      'cancel': 'ANNULER',
      'back': 'RETOUR',
      'admin_login': 'Connexion admin',
      'customer_login': 'Client',
      'admin': 'Admin',
      'welcome': 'Bienvenue à SeaFeast',

      // Menu
      'starters': 'Entrées',
      'main_courses': 'Plats principaux',
      'drinks': 'Boissons',
      'desserts': 'Desserts',
      'quantity': 'Quantité:',
      'add_to_cart': 'Ajouter au panier',
      'allergens': 'Allergènes',
      'browse_menu': 'Parcourir le menu',

      // Cart
      'basket': 'Panier',
      'empty_basket': 'Votre panier est vide',
      'empty_basket_desc': 'Parcourez le menu et ajoutez des articles.',
      'subtotal': 'Sous-total',
      'delivery_charge': 'Frais de livraison',
      'discount': 'Réduction',
      'total': 'Total',
      'continue_shopping': 'Annuler',

      // Checkout
      'payment_option': 'Choisissez votre mode de paiement',
      'cash': 'Espèces',
      'card': 'Mastercard',
      'no_card': 'Aucune carte ajoutée',
      'add_card': 'Vous pouvez ajouter une carte pour plus tard',
      'add_new': 'AJOUTER',
      'replace_card': 'REMPLACER',
      'card_saved': 'Carte enregistrée',
      'confirm_order': 'Confirmer la commande',
      'confirm_payment': 'Confirmer le paiement',
      'order_confirmed': 'Commande confirmée',
      'payment_successful': 'Paiement réussi',
      'order_placed': 'Votre commande a été passée!',
      'confirm_order_btn': 'Confirmer et payer',

      // Profile
      'view_profile': 'Voir le profil',
      'name': 'Nom',
      'date_of_birth': 'Date de naissance',
      'save_changes': 'Enregistrer',
      'profile_saved': 'Profil enregistré',

      // Home
      'reserve_table': 'Réserver une table',
      'view_profile_btn': 'Voir le profil',

      // Settings
      'language': 'Langue',
      'select_language': 'Sélectionner la langue',

      // Feedback (FR22)
      'feedback': 'Commentaires',
      'give_feedback': 'Donner un avis',
      'rate_experience': 'Évaluez votre expérience',
      'comments': 'Commentaires',
      'comments_hint': 'Parlez-nous de votre expérience...',
      'submit_feedback': 'Soumettre',
      'feedback_submitted': 'Merci pour vos commentaires!',

      // Booking (FR23, FR24)
      'book_table': 'Réserver une table',
      'select_date': 'Sélectionner la date',
      'select_time': 'Sélectionner l\'heure',
      'number_of_guests': 'Nombre de convives',
      'available_slots': 'Créneaux disponibles',
      'book_now': 'Réserver',
      'booking_confirmed': 'Réservation confirmée!',
      'booking_details': 'Votre table a été réservée.',
      'guests': 'convives',

      // Languages
      'english': 'Anglais',
      'french': 'Français',
      'spanish': 'Espagnol',
    },
    'es': {
      // Navigation
      'home': 'Inicio',
      'profile': 'Perfil',
      'menu': 'Menú',
      'cart': 'Cesta',
      'checkout': 'Pagar',

      // Auth
      'sign_in': 'Inicia sesión en tu cuenta',
      'sign_up': 'Crea tu cuenta',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'staff_id': 'ID del personal',
      'first_name': 'Nombre',
      'last_name': 'Apellido',
      'login': 'INICIAR SESIÓN',
      'logout': 'Cerrar sesión',
      'register': 'Registrarse',
      'cancel': 'CANCELAR',
      'back': 'VOLVER',
      'admin_login': 'Inicio de sesión admin',
      'customer_login': 'Cliente',
      'admin': 'Admin',
      'welcome': 'Bienvenido a SeaFeast',

      // Menu
      'starters': 'Entrantes',
      'main_courses': 'Platos principales',
      'drinks': 'Bebidas',
      'desserts': 'Postres',
      'quantity': 'Cantidad:',
      'add_to_cart': 'Añadir al carrito',
      'allergens': 'Alérgenos',
      'browse_menu': 'Ver menú',

      // Cart
      'basket': 'Cesta',
      'empty_basket': 'Tu cesta está vacía',
      'empty_basket_desc': 'Explora el menú y añade artículos.',
      'subtotal': 'Subtotal',
      'delivery_charge': 'Gastos de envío',
      'discount': 'Descuento',
      'total': 'Total',
      'continue_shopping': 'Cancelar',

      // Checkout
      'payment_option': 'Elige tu método de pago',
      'cash': 'Efectivo',
      'card': 'Mastercard',
      'no_card': 'No hay tarjeta añadida',
      'add_card': 'Puedes añadir una tarjeta para más tarde',
      'add_new': 'AÑADIR',
      'replace_card': 'REEMPLAZAR',
      'card_saved': 'Tarjeta guardada',
      'confirm_order': 'Confirmar pedido',
      'confirm_payment': 'Confirmar pago',
      'order_confirmed': 'Pedido confirmado',
      'payment_successful': 'Pago exitoso',
      'order_placed': '¡Tu pedido ha sido realizado!',
      'confirm_order_btn': 'Confirmar y pagar',

      // Profile
      'view_profile': 'Ver perfil',
      'name': 'Nombre',
      'date_of_birth': 'Fecha de nacimiento',
      'save_changes': 'Guardar cambios',
      'profile_saved': 'Perfil guardado',

      // Home
      'reserve_table': 'Reservar mesa',
      'view_profile_btn': 'Ver perfil',

      // Settings
      'language': 'Idioma',
      'select_language': 'Seleccionar idioma',

      // Feedback (FR22)
      'feedback': 'Opinión',
      'give_feedback': 'Dar opinión',
      'rate_experience': 'Califica tu experiencia',
      'comments': 'Comentarios',
      'comments_hint': 'Cuéntanos sobre tu experiencia...',
      'submit_feedback': 'Enviar',
      'feedback_submitted': '¡Gracias por tu opinión!',

      // Booking (FR23, FR24)
      'book_table': 'Reservar mesa',
      'select_date': 'Seleccionar fecha',
      'select_time': 'Seleccionar hora',
      'number_of_guests': 'Número de invitados',
      'available_slots': 'Horarios disponibles',
      'book_now': 'Reservar',
      'booking_confirmed': '¡Reserva confirmada!',
      'booking_details': 'Tu mesa ha sido reservada.',
      'guests': 'invitados',

      // Languages
      'english': 'Inglés',
      'french': 'Francés',
      'spanish': 'Español',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  String get home => translate('home');
  String get profile => translate('profile');
  String get menu => translate('menu');
  String get cart => translate('cart');
  String get checkout => translate('checkout');
  String get signIn => translate('sign_in');
  String get signUp => translate('sign_up');
  String get email => translate('email');
  String get password => translate('password');
  String get staffId => translate('staff_id');
  String get firstName => translate('first_name');
  String get lastName => translate('last_name');
  String get login => translate('login');
  String get logout => translate('logout');
  String get register => translate('register');
  String get cancel => translate('cancel');
  String get back => translate('back');
  String get adminLogin => translate('admin_login');
  String get customerLogin => translate('customer_login');
  String get admin => translate('admin');
  String get welcome => translate('welcome');
  String get starters => translate('starters');
  String get mainCourses => translate('main_courses');
  String get drinks => translate('drinks');
  String get desserts => translate('desserts');
  String get quantity => translate('quantity');
  String get addToCart => translate('add_to_cart');
  String get allergens => translate('allergens');
  String get browseMenu => translate('browse_menu');
  String get basket => translate('basket');
  String get emptyBasket => translate('empty_basket');
  String get emptyBasketDesc => translate('empty_basket_desc');
  String get subtotal => translate('subtotal');
  String get deliveryCharge => translate('delivery_charge');
  String get discount => translate('discount');
  String get total => translate('total');
  String get continueShopping => translate('continue_shopping');
  String get paymentOption => translate('payment_option');
  String get cash => translate('cash');
  String get card => translate('card');
  String get noCard => translate('no_card');
  String get addCard => translate('add_card');
  String get addNew => translate('add_new');
  String get replaceCard => translate('replace_card');
  String get cardSaved => translate('card_saved');
  String get confirmOrder => translate('confirm_order');
  String get confirmPayment => translate('confirm_payment');
  String get orderConfirmed => translate('order_confirmed');
  String get paymentSuccessful => translate('payment_successful');
  String get orderPlaced => translate('order_placed');
  String get confirmOrderBtn => translate('confirm_order_btn');
  String get viewProfile => translate('view_profile');
  String get name => translate('name');
  String get dateOfBirth => translate('date_of_birth');
  String get saveChanges => translate('save_changes');
  String get profileSaved => translate('profile_saved');
  String get reserveTable => translate('reserve_table');
  String get viewProfileBtn => translate('view_profile_btn');
  String get language => translate('language');
  String get selectLanguage => translate('select_language');
  String get feedback => translate('feedback');
  String get giveFeedback => translate('give_feedback');
  String get rateExperience => translate('rate_experience');
  String get comments => translate('comments');
  String get commentsHint => translate('comments_hint');
  String get submitFeedback => translate('submit_feedback');
  String get feedbackSubmitted => translate('feedback_submitted');
  String get bookTable => translate('book_table');
  String get selectDate => translate('select_date');
  String get selectTime => translate('select_time');
  String get numberOfGuests => translate('number_of_guests');
  String get availableSlots => translate('available_slots');
  String get bookNow => translate('book_now');
  String get bookingConfirmed => translate('booking_confirmed');
  String get bookingDetails => translate('booking_details');
  String get guests => translate('guests');
  String get english => translate('english');
  String get french => translate('french');
  String get spanish => translate('spanish');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}