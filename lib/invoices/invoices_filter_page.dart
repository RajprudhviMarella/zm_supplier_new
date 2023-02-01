import 'package:flutter/material.dart';
import 'package:zm_supplier/utils/color.dart';

class InvoicesFilterPage extends StatefulWidget {
  List<String> selectedFilters = [];

  InvoicesFilterPage(this.selectedFilters);

  @override
  State<StatefulWidget> createState() =>
      InvoicesFilterState(this.selectedFilters);
}

class InvoicesFilterState extends State<InvoicesFilterPage> {
  var statusArr = ['Not yet due', 'Overdue', 'Paid'];

  bool isPresent(String paymentStatus) {
    print(selectedStatus);
    return selectedStatus.contains(paymentStatus);
  }

  List<String> selectedStatus =
      []; //<String>['Not yet due', 'Overdue', 'Paid'];

  InvoicesFilterState(this.selectedStatus);

  @override
  void initState() {
    if (selectedStatus == null) {
      selectedStatus = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //  key: globalKey,
      backgroundColor: faintGrey,
      appBar: buildAppBar(context),
      body: ListView(
        children: <Widget>[headers(), statusList(), button()],
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Filter',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'SourceSansProBold'),
        ),
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: Center(
            child: GestureDetector(
          onTap: () {
            selectedStatus = [];
            setState(() {});
          },
          child: Text(
            '   Reset',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'SourceSansProRegular'),
          ),
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.black), //Image(

            onPressed: () {
              Navigator.of(context).pop(selectedStatus);
            },
          ),
        ]);
  }

  Widget headers() {
    return Container(
      color: faintGrey,
      padding: const EdgeInsets.only(left: 15.0, top: 22),
      height: 60,
      child: Text(
        'Payment status',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontFamily: 'SourceSansProBold'),
      ),
    );
  }

  Widget statusList() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: statusArr.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(children: <Widget>[
            ListTile(
              tileColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  statusArr[index],
                  style: TextStyle(
                      fontSize: 16, fontFamily: "SourceSansProRegular"),
                ),
              ),
              onTap: () {
                if (isPresent(statusArr[index])) {
                  selectedStatus.remove(statusArr[index].toString());
                } else {
                  selectedStatus.add(statusArr[index].toString());
                }
                setState(() {});
                print(selectedStatus);
              },
              trailing: trailingIcon(index),
            ),
            Divider(
              height: 1.5,
              color: faintGrey,
            )
          ]);
        });
  }

  Widget trailingIcon(int index) {
    if (isPresent(statusArr[index])) {
      return Container(
          height: 20,
          width: 20,
          child: ImageIcon(
            AssetImage('assets/images/icon-tick-green.png'),
            size: 22,
            color: buttonBlue,
          ));
    } else {
      return Container(height: 20, width: 20);
    }
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 300, right: 20),
      child: Container(
        height: 50,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          onPressed: () {
            Navigator.of(context).pop(selectedStatus);
          },
          child: const Text('Save',
              style:
                  TextStyle(fontSize: 16, fontFamily: 'SorceSansProSemiBold')),
          color: buttonBlue,
          textColor: Colors.white,
        ),
      ),
    );
  }
}
