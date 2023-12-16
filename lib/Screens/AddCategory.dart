import 'package:budget_buddy/Constants/IconList.dart';
import 'package:budget_buddy/Constants/SendSnackBar.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  var titleController = TextEditingController();
  var iconController = TextEditingController();

  var searchController = TextEditingController();

  String _categoryType = "Expense";

  var title;

  IconData selectedIcon = Icons.local_dining;
  bool darkModeEnabled = false;

  // Working with interstitial ads

  late InterstitialAd _interstitialAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _initAd();
  }

  void _initAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-9078201720890090/1701830991',
      // test ad uint :
      // adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    setState(() {
      _isLoaded = true;
    });

    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
      },
    );
  }

  showInterstitialAd() {
    if (_isLoaded) {
      return _interstitialAd.show();
    } else {
      return (Text("Interstitial ad is not loaded yet."),);
    }
  }

  @override
  Widget build(BuildContext context) {
    darkModeEnabled = Provider.of<StateProvider>(context).darkTheme;

    saveCategory(dynamic type, dynamic title, dynamic icon) async {
      var newCategory = {"type": type, "title": title, "icon": icon};
      context.read<StateProvider>().saveCategory(newCategory);
    }

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: _categoryType == "Expense"
          ? darkModeEnabled
              ? Color.fromARGB(255, 112, 112, 112)
              : Color.fromARGB(255, 196, 214, 222)
          : darkModeEnabled
              ? Color.fromARGB(255, 112, 112, 112)
              : Color.fromARGB(255, 210, 219, 200),
      appBar: AppBar(
        title: const Text(
          'Add Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRadioOption("Expense"),
                  const SizedBox(width: 16),
                  _buildRadioOption("Income"),
                ],
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: TextFormField(
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  controller: titleController,
                  onChanged: (val) {
                    title = val.trim();
                  },
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Give a title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Icon',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                ),
                itemCount: iconList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = iconList[index];
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: selectedIcon == iconList[index]
                          ? Colors.lightBlue
                          : Colors.transparent,
                      child: Icon(
                        iconList[index],
                        color: darkModeEnabled ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  showInterstitialAd();
                  // await InterstitialAdWidget();
                  if (formKey.currentState!.validate()) {
                    String hexCodePoint =
                        '0x${selectedIcon.codePoint.toRadixString(16).toUpperCase()}';

                    saveCategory(_categoryType, title, hexCodePoint);

                    sendSnackBar(context, "Category Added");

                    Navigator.of(context).pop();
                  } else {
                    sendSnackBar(context, "Provide the title");
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text(
                      'Save Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String option) {
    return InkWell(
      onTap: () {
        setState(() {
          _categoryType = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _categoryType == option ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _categoryType == option ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          option,
          style: TextStyle(
            fontSize: 16,
            color: _categoryType == option
                ? Colors.white
                : darkModeEnabled
                    ? Colors.white
                    : Colors.black,
            // color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
