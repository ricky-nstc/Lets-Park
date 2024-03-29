import 'package:flutter/material.dart';

class SharedWidget {
  AppBar appBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  Center headerWithLogo() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/lets-park-logo.png',
            width: 100,
          ),
          const Text(
            "7TH DEVS",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Text note(String note) {
    return Text(
      note,
      style: const TextStyle(
        fontSize: 23,
      ),
    );
  }

  Text stepHeader(String label) => Text(
        label,
        style: const TextStyle(
          fontSize: 25,
          color: Colors.blue,
        ),
      );

  TextFormField textFormField({
    required TextInputAction action,
    required TextEditingController controller,
    String? label,
    String? hintText,
    TextInputType textInputType = TextInputType.text,
    bool obscure = false,
    bool readOnly = false,
    Widget? icon,
    int? maxLength,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      textInputAction: action,
      maxLength: maxLength,
      controller: controller,
      obscureText: obscure,
      readOnly: readOnly,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon,
        label: Text(label ?? ""),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      validator: validator,
    );
  }

  ElevatedButton button({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.lightBlue,
        fixedSize: const Size(140, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  AppBar appbarDrawer({required String title, VoidCallback? onPressed}) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: onPressed,
      ),
      elevation: 2,
      bottom: PreferredSize(
        child: Container(
          color: Colors.white,
          height: 40,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(40),
      ),
    );
  }

  AppBar manageSpaceAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      bottom: PreferredSize(
        child: Container(
          color: Colors.white,
          height: 40,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        preferredSize: const Size.fromHeight(40),
      ),
    );
  }
}
