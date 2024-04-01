import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodie/components/scalton/big_card_scalton.dart';

import '../../components/cards/big/restaurant_info_big_card.dart';
import '../../constants.dart';
import '../../demoData.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key); // Added Key parameter

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _showSearchResult = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delayed the isLoading state to provide a smoother transition
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void showResult() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showSearchResult = true;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: defaultPadding),
              Text(
                'Search',
                style: Theme.of(context).textTheme.titleLarge,
              ), // Used headline6 for consistent typography
              const SizedBox(height: defaultPadding),
              const SearchForm(),
              const SizedBox(height: defaultPadding),
              Text(
                _showSearchResult ? "Search Results" : "Top Restaurants",
                style: Theme.of(context).textTheme.titleMedium,
              ), // Used subtitle1 for consistent typography
              const SizedBox(height: defaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: _isLoading ? 2 : 5,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: defaultPadding),
                    child: _isLoading
                        ? const BigCardScalton() // Renamed from Scalton to Skeleton
                        : RestaurantInfoBigCard(
                            images: demoBigImages..shuffle(),
                            name: "McDonald's",
                            rating: 4.3,
                            numOfRating: 200,
                            deliveryTime: 25,
                            foodType: const [
                              "Chinese",
                              "American",
                              "Deshi food"
                            ],
                            press: () {},
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({Key? key}) : super(key: key); // Added Key parameter

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        onChanged: (value) {
          // Implement your logic here
        },
        onFieldSubmitted: (value) {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            // Implement submit action
          } else {
            // Implement error handling
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a search query'; // Added validation message
          }
          return null;
        },
        style: Theme.of(context).textTheme.bodyLarge, // Adjusted text style
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search on foodie",
          contentPadding: kTextFieldPadding,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: bodyTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
