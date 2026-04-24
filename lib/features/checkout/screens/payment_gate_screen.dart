import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/app_theme.dart';
import '../../../error_handler.dart'; // Import the error handler
import '../../../core/widgets/common_widgets.dart';

class PaymentGateScreen extends StatefulWidget {
  const PaymentGateScreen({super.key});

  @override
  State<PaymentGateScreen> createState() => _PaymentGateScreenState();
}

enum PaymentMethodType { card, cash, transfer }

class _PaymentGateScreenState extends State<PaymentGateScreen> {
  bool _isProcessing = false;
  PaymentMethodType _selectedMethod = PaymentMethodType.card;

  // Card Controllers
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  bool _validateCardForm() {
    final cardNum = _cardNumberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text.trim();
    final cvv = _cvvController.text.trim();

    if (cardNum.length < 16) {
      _showValidationError('يرجى إدخال رقم البطاقة كاملاً (16 رقم)');
      return false;
    }
    if (expiry.length < 4) {
      _showValidationError('يرجى إدخال تاريخ انتهاء البطاقة');
      return false;
    }
    if (cvv.length < 3) {
      _showValidationError('يرجى إدخال رمز CVV (3 أرقام)');
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    AppErrorHandler.showError(message);
  }

  Future<void> _processPayment() async {
    // Validate card form if card method is selected
    if (_selectedMethod == PaymentMethodType.card && !_validateCardForm()) {
      return;
    }

    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isProcessing = false);
      context.go(AppRoutes.paymentSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('اختيار طريقة الدفع',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildMethodSelector(),
            const SizedBox(height: 32),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _buildSelectedMethodView(),
            ),
            const SizedBox(height: 40),
            _buildSafetyNote(),
            const SizedBox(
                height:
                    40), // Reduced from 120 since we are using bottomNavigationBar now
          ],
        ),
      ),
      // CHANGED: Using bottomNavigationBar instead of bottomSheet
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildMethodSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildMethodTab(
              PaymentMethodType.card, Icons.credit_card_rounded, 'بطاقة بنكية'),
          _buildMethodTab(PaymentMethodType.cash,
              Icons.account_balance_wallet_rounded, 'نقداً'),
          _buildMethodTab(
              PaymentMethodType.transfer, Icons.sync_alt_rounded, 'تحويل بنكي'),
        ],
      ),
    );
  }

  Widget _buildMethodTab(
      PaymentMethodType method, IconData icon, String label) {
    final isSelected = _selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMethod = method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), // CHANGED
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 20,
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.textTertiary),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedMethodView() {
    switch (_selectedMethod) {
      case PaymentMethodType.card:
        return _buildCardView();
      case PaymentMethodType.cash:
        return _buildCashView();
      case PaymentMethodType.transfer:
        return _buildTransferView();
    }
  }

  Widget _buildCardView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCreditCard(),
          const SizedBox(height: 32),
          const AppSectionTitle(title: 'تفاصيل البطاقة البنكية (CMI)'),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'رقم البطاقة',
            controller: _cardNumberController,
            hint: '0000 0000 0000 0000',
            icon: Icons.credit_card_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildInputField(
                  label: 'تاريخ الانتهاء',
                  controller: _expiryController,
                  hint: 'MM/YY',
                  icon: Icons.calendar_today_rounded,
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildInputField(
                  label: 'CVV',
                  controller: _cvvController,
                  hint: '123',
                  icon: Icons.lock_outline_rounded,
                  keyboardType: TextInputType.number,
                  obscure: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('البنوك المغربية المدعومة:',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          _buildBankLogos(),
        ],
      ),
    );
  }

  Widget _buildCashView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03), // CHANGED
                  blurRadius: 15,
                  offset: const Offset(0, 5))
            ],
          ),
          child: Column(
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Wafacash_logo.png/800px-Wafacash_logo.png',
                height: 40,
                errorBuilder: (_, __, ___) => const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 40,
                    color: Colors.orange),
              ),
              const SizedBox(height: 24),
              const Text(AppStrings.paymentReference,
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'DR-928-341-001',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppColors.primaryBlue),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                      const ClipboardData(text: 'DR-928-341-001'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('تم نسخ المرجع بنجاح!'),
                      backgroundColor: AppColors.emeraldGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copy_rounded,
                        size: 16, color: AppColors.primaryBlue),
                    SizedBox(width: 8),
                    Text(AppStrings.copyReference,
                        style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05), // CHANGED
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.1)), // CHANGED
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: Colors.blue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.cashInstructions,
                  style: TextStyle(
                      fontSize: 12, color: Colors.blue.shade700, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransferView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionTitle(title: 'تفاصيل الحساب البنكي'),
          const SizedBox(height: 20),
          _buildDetailRow(AppStrings.bankName, AppStrings.bankAttijari),
          const Divider(height: 32),
          _buildDetailRow(AppStrings.bankAccountHolder, 'Dorousi SARL AU'),
          const Divider(height: 32),
          _buildDetailRow(AppStrings.ribNumber, '007 780 0001234567890123 45'),
          const SizedBox(height: 24),
          Center(
            child: InkWell(
              onTap: () {
                Clipboard.setData(
                    const ClipboardData(text: '007 780 0001234567890123 45'));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('تم نسخ رقم الحساب بنجاح!'),
                    backgroundColor: AppColors.emeraldGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.08), // CHANGED
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy_rounded,
                        size: 14, color: AppColors.primaryBlue),
                    SizedBox(width: 6),
                    Text('نسخ رقم الحساب',
                        style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'يرجى إرسال نسخة من وصل التحويل عبر الواتساب لتفعيل حسابك فوراً.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11, color: AppColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue)),
      ],
    );
  }

  Widget _buildCreditCard() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.3), // CHANGED
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(0.05), // CHANGED
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.contactless_rounded,
                        color: Colors.white, size: 32),
                    Image.network(
                      'https://www.cmi.co.ma/sites/default/files/Logo_CMI_0.png',
                      height: 25,
                      errorBuilder: (_, __, ___) => const Text('CMI',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  '**** **** **** 4242',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CARD HOLDER',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6), // CHANGED
                                fontSize: 10)),
                        const Text('AHMED VICTOR',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Icon(Icons.credit_card, color: Colors.white54),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankLogos() {
    const logos = [
      'https://upload.wikimedia.org/wikipedia/fr/4/48/Attijariwafa_Bank_logo.png',
      'https://upload.wikimedia.org/wikipedia/commons/d/df/Logo_Banque_Populaire.png',
      'https://upload.wikimedia.org/wikipedia/fr/5/52/Logo_BMCE_Bank.png',
      'https://upload.wikimedia.org/wikipedia/commons/7/70/Logo_CIH_Bank.png',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: logos
          .map((url) => Container(
                height: 35,
                width: 60,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Image.network(url,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.account_balance, size: 20)),
              ))
          .toList(),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.textTertiary, fontSize: 14),
            prefixIcon: Icon(icon, size: 20, color: AppColors.primaryBlue),
            filled: true,
            fillColor: AppColors.inputFill,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.primaryBlue, width: 1.5)),
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emeraldGreen.withOpacity(0.05), // CHANGED
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.emeraldGreen.withOpacity(0.1)), // CHANGED
      ),
      child: Row(
        children: [
          const Icon(Icons.security_rounded,
              color: AppColors.emeraldGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'بياناتك محمية ومشفرة بالكامل. دروسي لا تقوم بتخزين تفاصيل بطاقتك البنكية.',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.emeraldGreen.withOpacity(0.8), // CHANGED
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    String buttonText;
    switch (_selectedMethod) {
      case PaymentMethodType.card:
        buttonText = 'إتمام الدفع بالبطاقة';
        break;
      case PaymentMethodType.cash:
        buttonText = 'تأكيد بمرجع الدفع النقدي';
        break;
      case PaymentMethodType.transfer:
        buttonText = 'تأكيد التحويل البنكي';
        break;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
          24, 16, 24, 16), // Added bottom padding for nav bar
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
            top: BorderSide(
                color: AppColors.divider.withOpacity(0.5))), // CHANGED
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(DourousiTheme.kBorderRadius),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3), // CHANGED
                  blurRadius: 15,
                  offset: const Offset(0, 6)),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DourousiTheme.kBorderRadius)),
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5))
                : Text(buttonText,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
