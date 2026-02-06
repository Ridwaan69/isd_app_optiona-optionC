// lib/app_localizations.dart
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

      // ===================== CUSTOM STRINGS =====================
      //SAFE TO KEEP DURING MERGING (for Option C)
      'orders': 'Orders', // Added for side drawer
      "bestSellingDishes": "Best Selling Dishes",

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
      'cancel': 'Cancel',
      'back': 'BACK',
      'admin_login': 'Admin Log in',
      'customer_login': 'Customer',
      'admin': 'Admin',
      'welcome': 'Welcome to SeaFeast',
      'dont_have_account': "Don't have an account?",
      'sign_up_small': 'Sign up',
      'enter_valid_email': 'Enter a valid email',
      'min_4_characters': 'Min 4 characters',
      'enter_staff_id': 'Enter Staff ID',
      'signing_in': 'Signing in...',
      'back_btn': 'BACK',
      'create_account_title': 'Create your account',
      'reenter_password': 'Re-enter password',
      'confirm_password': 'Confirm your password',
      'min_6_characters': 'Min 6 characters',
      'passwords_do_not_match': 'Passwords do not match',
      'already_have_account': 'Already have an account?',

      // Menu
      'starters': 'Starters',
      'main_courses': 'Main Courses',
      'drinks': 'Drinks',
      'desserts': 'Desserts',
      'quantity': 'Quantity:',
      'add_to_cart': 'Add to Cart',
      'allergens': 'Allergens',
      'browse_menu': 'Browse menu',
      'item_added_to_cart': 'added to cart',

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
      'please_add_card_or_cash': 'Please add a card or choose Cash',
      'you_chose_cash':
          'You chose Cash. Confirm the order? Payment will be done upon on delivery',
      'pay_with_card': 'Pay with **** **** ****',
      'confirm': 'Confirm',
      'would_you_rate': 'Would you like to rate your experience?',
      'maybe_later': 'Maybe Later',
      'rate_now': 'Rate Now',
      'card_holder': 'Card holder',
      'add_card_title': 'Add Card',
      'card_holder_name': 'CARD HOLDER NAME',
      'card_number': 'CARD NUMBER',
      'expire_date': 'EXPIRE DATE',
      'cvc': 'CVC',
      'add_and_pay': 'Add and Make Payment',
      'required': 'Required',
      'enter_valid_number': 'Enter a valid number',
      'invalid_date': 'Invalid date',
      'invalid_cvc': 'Invalid CVC',

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
      'feedback_appreciation':
          'We appreciate your feedback and will use it to improve our service.',
      'help_us_improve': 'Help us improve your dining experience',
      'please_share_feedback': 'Please share your feedback',
      'provide_detailed_feedback':
          'Please provide more detailed feedback (min 10 characters)',
      'rating_poor': 'Poor',
      'rating_fair': 'Fair',
      'rating_good': 'Good',
      'rating_very_good': 'Very Good',
      'rating_excellent': 'Excellent',
      'ok': 'OK',

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

      //SAFE TO KEEP for Option C (SHOULD KEEP)
      'orders': 'Commandes', // Added for side drawer
      "bestSellingDishes": "Plats les plus vendus",

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
      'cancel': 'Annuler',
      'back': 'RETOUR',
      'admin_login': 'Connexion admin',
      'customer_login': 'Client',
      'admin': 'Admin',
      'welcome': 'Bienvenue à SeaFeast',
      'create_account_title': 'Créer votre compte',
      'reenter_password': 'Ressaisir le mot de passe',
      'confirm_password': 'Confirmez votre mot de passe',
      'min_6_characters': 'Minimum 6 caractères',
      'passwords_do_not_match': 'Les mots de passe ne correspondent pas',
      'already_have_account': 'Vous avez déjà un compte ?',
      'enter_valid_email': 'Entrez un email valide',
      'dont_have_account': "Vous n'avez pas de compte ?",
      'sign_up_small': "S'inscrire",
      'min_4_characters': 'Minimum 4 caractères',
      'enter_staff_id': "Entrez l'ID du personnel",
      'signing_in': 'Connexion...',
      'back_btn': 'RETOUR',

      // Menu
      'starters': 'Entrées',
      'main_courses': 'Plats principaux',
      'drinks': 'Boissons',
      'desserts': 'Desserts',
      'quantity': 'Quantité:',
      'add_to_cart': 'Ajouter au panier',
      'allergens': 'Allergènes',
      'browse_menu': 'Parcourir le menu',
      'item_added_to_cart': 'ajouté au panier',

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
      'please_add_card_or_cash':
          'Veuillez ajouter une carte ou choisir Espèces',
      'you_chose_cash':
          'Vous avez choisi Espèces. Confirmer la commande? Le paiement sera effectué à la livraison',
      'pay_with_card': 'Payer avec **** **** ****',
      'confirm': 'Confirmer',
      'would_you_rate': 'Souhaitez-vous évaluer votre expérience?',
      'maybe_later': 'Plus tard',
      'rate_now': 'Évaluer',
      'card_holder': 'Titulaire de la carte',
      'add_card_title': 'Ajouter une carte',
      'card_holder_name': 'NOM DU TITULAIRE',
      'card_number': 'NUMÉRO DE CARTE',
      'expire_date': 'DATE D\'EXPIRATION',
      'cvc': 'CVC',
      'add_and_pay': 'Ajouter et payer',
      'required': 'Requis',
      'enter_valid_number': 'Entrez un numéro valide',
      'invalid_date': 'Date invalide',
      'invalid_cvc': 'CVC invalide',

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
      'feedback_appreciation':
          'Nous apprécions vos commentaires et les utiliserons pour améliorer notre service.',
      'help_us_improve': 'Aidez-nous à améliorer votre expérience culinaire',
      'please_share_feedback': 'Veuillez partager vos commentaires',
      'provide_detailed_feedback':
          'Veuillez fournir des commentaires plus détaillés (min 10 caractères)',
      'rating_poor': 'Médiocre',
      'rating_fair': 'Passable',
      'rating_good': 'Bien',
      'rating_very_good': 'Très bien',
      'rating_excellent': 'Excellent',
      'ok': 'OK',

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

      //SAFE TO KEEP for Option C(SHOULD KEEP)
      'orders': 'Pedidos', // Added for side drawer
      "bestSellingDishes": "Platos más vendidos",

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
      'cancel': 'Cancelar',
      'back': 'VOLVER',
      'admin_login': 'Inicio de sesión admin',
      'customer_login': 'Cliente',
      'admin': 'Admin',
      'welcome': 'Bienvenido a SeaFeast',
      'create_account_title': 'Crea tu cuenta',
      'reenter_password': 'Vuelve a ingresar la contraseña',
      'confirm_password': 'Confirma tu contraseña',
      'min_6_characters': 'Mínimo 6 caracteres',
      'passwords_do_not_match': 'Las contraseñas no coinciden',
      'already_have_account': '¿Ya tienes una cuenta?',
      'enter_valid_email': 'Ingresa un correo válido',
      'dont_have_account': "¿No tienes una cuenta?",
      'sign_up_small': 'Regístrate',
      'min_4_characters': 'Mínimo 4 caracteres',
      'enter_staff_id': 'Ingresa ID del personal',
      'signing_in': 'Iniciando sesión...',
      'back_btn': 'VOLVER',

      // Menu
      'starters': 'Entrantes',
      'main_courses': 'Platos principales',
      'drinks': 'Bebidas',
      'desserts': 'Postres',
      'quantity': 'Cantidad:',
      'add_to_cart': 'Añadir al carrito',
      'allergens': 'Alérgenos',
      'browse_menu': 'Ver menú',
      'item_added_to_cart': 'añadido al carrito',

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
      'please_add_card_or_cash': 'Por favor añade una tarjeta o elige Efectivo',
      'you_chose_cash':
          'Elegiste Efectivo. ¿Confirmar el pedido? El pago se realizará en la entrega',
      'pay_with_card': 'Pagar con **** **** ****',
      'confirm': 'Confirmar',
      'would_you_rate': '¿Te gustaría calificar tu experiencia?',
      'maybe_later': 'Quizás más tarde',
      'rate_now': 'Calificar ahora',
      'card_holder': 'Titular de la tarjeta',
      'add_card_title': 'Añadir tarjeta',
      'card_holder_name': 'NOMBRE DEL TITULAR',
      'card_number': 'NÚMERO DE TARJETA',
      'expire_date': 'FECHA DE VENCIMIENTO',
      'cvc': 'CVC',
      'add_and_pay': 'Añadir y pagar',
      'required': 'Requerido',
      'enter_valid_number': 'Ingresa un número válido',
      'invalid_date': 'Fecha inválida',
      'invalid_cvc': 'Invalid CVC',

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
      'feedback_appreciation':
          'Apreciamos tus comentarios y los usaremos para mejorar nuestro servicio.',
      'help_us_improve': 'Ayúdanos a mejorar tu experiencia gastronómica',
      'please_share_feedback': 'Por favor comparte tus comentarios',
      'provide_detailed_feedback':
          'Por favor proporciona comentarios más detallados (mín 10 caracteres)',
      'rating_poor': 'Malo',
      'rating_fair': 'Regular',
      'rating_good': 'Bueno',
      'rating_very_good': 'Muy bueno',
      'rating_excellent': 'Excelente',
      'ok': 'OK',

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
  String get itemAddedToCart => translate('item_added_to_cart');
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
  String get pleaseAddCardOrCash => translate('please_add_card_or_cash');
  String get youChoseCash => translate('you_chose_cash');
  String get payWithCard => translate('pay_with_card');
  String get confirm => translate('confirm');
  String get wouldYouRate => translate('would_you_rate');
  String get maybeLater => translate('maybe_later');
  String get rateNow => translate('rate_now');
  String get cardHolder => translate('card_holder');
  String get addCardTitle => translate('add_card_title');
  String get cardHolderName => translate('card_holder_name');
  String get cardNumber => translate('card_number');
  String get expireDate => translate('expire_date');
  String get cvc => translate('cvc');
  String get addAndPay => translate('add_and_pay');
  String get required => translate('required');
  String get enterValidNumber => translate('enter_valid_number');
  String get invalidDate => translate('invalid_date');
  String get invalidCvc => translate('invalid_cvc');
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
  String get feedbackAppreciation => translate('feedback_appreciation');
  String get helpUsImprove => translate('help_us_improve');
  String get pleaseShareFeedback => translate('please_share_feedback');
  String get provideDetailedFeedback => translate('provide_detailed_feedback');
  String get ratingPoor => translate('rating_poor');
  String get ratingFair => translate('rating_fair');
  String get ratingGood => translate('rating_good');
  String get ratingVeryGood => translate('rating_very_good');
  String get ratingExcellent => translate('rating_excellent');
  String get ok => translate('ok');
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

  // >>> Added getters for Sign Up screen (missing strings) <<<
  String get createAccountTitle => translate('create_account_title');
  String get reenterPassword => translate('reenter_password');
  String get confirmPassword => translate('confirm_password');
  String get min6Characters => translate('min_6_characters');
  String get passwordsDoNotMatch => translate('passwords_do_not_match');
  String get alreadyHaveAccount => translate('already_have_account');
  String get enterValidEmail => translate('enter_valid_email');
  String get dontHaveAccount => translate('dont_have_account');
  String get signUpSmall => translate('sign_up_small');
  String get min4Characters => translate('min_4_characters');
  String get enterStaffId => translate('enter_staff_id');
  String get signingIn => translate('signing_in');
  String get backBtn => translate('back_btn');

  // >>> Getter for Manage Orders button (side drawer) <<<(OPTION C)
  String get manageOrders => translate('orders');
  //Option C (SAFE TO KEEP)
  String get bestSellingDishes => translate('bestSellingDishes');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
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
