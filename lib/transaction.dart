import 'package:bills_plug/transaction_details.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  TransactionPageState createState() => TransactionPageState();
}

class TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _search2FocusNode = FocusNode();
  final FocusNode _search3FocusNode = FocusNode();
  final FocusNode _search4FocusNode = FocusNode();
  final FocusNode _search5FocusNode = FocusNode();
  final FocusNode _search6FocusNode = FocusNode();
  final FocusNode _search7FocusNode = FocusNode();
  final FocusNode _search8FocusNode = FocusNode();
  final FocusNode _search9FocusNode = FocusNode();
  final FocusNode _search10FocusNode = FocusNode();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController search2Controller = TextEditingController();
  final TextEditingController search3Controller = TextEditingController();
  final TextEditingController search4Controller = TextEditingController();
  final TextEditingController search5Controller = TextEditingController();
  final TextEditingController search6Controller = TextEditingController();
  final TextEditingController search7Controller = TextEditingController();
  final TextEditingController search8Controller = TextEditingController();
  final TextEditingController search9Controller = TextEditingController();
  final TextEditingController search10Controller = TextEditingController();

  TabController? _tabController;

  final List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  final ScrollController _scrollController = ScrollController();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _tabController = TabController(length: 10, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchTransactions();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
    _scrollController.dispose();
  }

  Future<void> _fetchTransactions() async {
    // Check if we're already loading or if we've fetched all pages
    if (_isLoading || _currentPage > _totalPages) return;

    setState(() {
      _isLoading = true; // Indicate loading state
    });

    try {
      final data = await fetchTransactions(_currentPage);

      // Check if the 'data' key exists and is a List
      if (data['data'] != null && data['data'] is List) {
        _totalPages = data['pagination']['total_pages'];

        // Cast newTransactions as List<Map<String, dynamic>>
        final List<Map<String, dynamic>> newTransactions =
            List<Map<String, dynamic>>.from(data['data']);

        // Update the transaction list with new transactions
        _transactions.addAll(
            newTransactions); // Combine new transactions into the existing list

        // You can also log or process transactions here if needed
        for (var item in newTransactions) {
          String type = item['trx_type'] ?? 'Unknown'; // Handle potential null
          String timeStamp =
              item['created_at'] ?? 'No timestamp'; // Handle potential null
          String amount = item['amount'] ?? '0.00'; // Handle potential null

          // Print the transaction for debugging
          print('Transaction: $type, $timeStamp, $amount');
        }

        setState(() {
          _currentPage++; // Increment the current page for the next fetch
          _isLoading = false; // Reset loading state
        });
      } else {
        print('Invalid response structure: $data');
        setState(() {
          _isLoading = false; // Reset loading state on invalid response
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Reset loading state on error
      });
      print('Error fetching transactions: $error');
    }
  }

  Future<Map<String, dynamic>> fetchTransactions(int page) async {
    // Fetch the access token from storage
    final accessToken = await storage.read(key: 'billsplug_accessToken');

    final response = await http.post(
      Uri.parse('http://glad.payguru.com.ng/api/transactions'),
      body: json.encode({'page': page}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Add the token to the headers
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Decode the response body
    } else {
      throw Exception('Failed to load transactions: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20.0, bottom: 0.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFF02AA03),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset(
                                        'images/BackButton_White.png',
                                        height: 40,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2),
                                    const Text(
                                      'Transaction',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.05),
                              TabBar(
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                controller: _tabController,
                                tabs: [
                                  _buildTab('Airtime'),
                                  _buildTab('Data'),
                                  _buildTab('Cable TV'),
                                  _buildTab('Electricity'),
                                  _buildTab('Betting'),
                                  _buildTab('Exam Pin'),
                                  _buildTab('Jamb E-Pin'),
                                  _buildTab('Data Pin'),
                                  _buildTab('Airtime Pin'),
                                  _buildTab('Airtime2cash'),
                                ],
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white,
                                labelStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                                labelPadding: EdgeInsets.zero,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              ListView(
                                controller: _scrollController,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: searchController,
                                      focusNode: _searchFocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  ..._transactions.map((transaction) {
                                    String type = transaction['trx_type'] ??
                                        'Unknown'; // Access the raw data directly
                                    String timeStamp = transaction[
                                            'created_at'] ??
                                        'No timestamp'; // Handle potential null
                                    String amount = transaction['amount'] ??
                                        '0.00'; // Handle potential null

                                    return transactionWidget(
                                      'images/MTNImg.png', // You can choose to update this based on transaction type
                                      type,
                                      timeStamp,
                                      amount,
                                    );
                                  }).toList(),
                                  if (_isLoading)
                                    const Center(
                                        child: CircularProgressIndicator()),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search2Controller,
                                      focusNode: _search2FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  transactionWidget(
                                      'images/MTNImg.png',
                                      '10.0GB MTN Data',
                                      '08 Feb, 12:12 PM',
                                      '1500.00'),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search3Controller,
                                      focusNode: _search3FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  transactionWidget(
                                      'images/GoTVImg.png',
                                      'Subscription',
                                      '08 Feb, 12:12 PM',
                                      '1500.00'),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search4Controller,
                                      focusNode: _search4FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search5Controller,
                                      focusNode: _search5FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search6Controller,
                                      focusNode: _search6FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search7Controller,
                                      focusNode: _search7FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search8Controller,
                                      focusNode: _search8FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search9Controller,
                                      focusNode: _search9FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                ],
                              ),
                              ListView(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Text(
                                      'Recent Transaction',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: const Divider(
                                        color: Colors.grey,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: search10Controller,
                                      focusNode: _search10FocusNode,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Search...',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Inter',
                                          fontSize: 15.0,
                                          decoration: TextDecoration.none,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                              width: 3,
                                              color: Color(0xFF02AA03)),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      cursorColor: const Color(0xFF02AA03),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04),
                                ],
                              ),
                            ],
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
      },
    );
  }

  Widget transactionWidget(
      String img, String type, String timeStamp, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetails(
                key: UniqueKey(),
              ),
            ),
          );
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: SizedBox(
                    width: (55 / MediaQuery.of(context).size.width) *
                        MediaQuery.of(context).size.width,
                    height: (55 / MediaQuery.of(context).size.height) *
                        MediaQuery.of(context).size.height,
                    child: Image.asset(
                      img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        timeStamp,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                          Image.asset(
                            'images/NairaImg.png',
                            height: 15,
                          ),
                          Text(
                            amount,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        "images/icons/AppIcon.png",
                        fit: BoxFit.contain,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Divider(
                color: Colors.grey,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String name) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(name),
      ),
    );
  }
}

class Transaction {
  final int id;
  final String type;
  final String timeStamp;
  final String amount;

  Transaction({
    required this.id,
    required this.type,
    required this.timeStamp,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      timeStamp: json['created_at'],
      amount: json['amount'],
    );
  }
}
