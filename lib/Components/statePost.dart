import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/data_block.dart';
import '../model/cargo.dart' as MyCargo;
import '../model/cargo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickUpController = TextEditingController();
  final TextEditingController _dropOffController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _cargoTypeController = TextEditingController();
  final TextEditingController _cargoOwnerController = TextEditingController();
  final TextEditingController _packagingController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
      ),
      body: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is DataInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DataLoaded) {
            final data = state.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                Cargo item = data[index] as MyCargo.Cargo;
                return ListTile(
                  title: Text(item
                      .pickUp), // Display the pickUp property of the Cargo object
                );
              },
            );
          } else if (state is DataError) {
            return Center(
              child: Text(state.message),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Post Cargo'),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _pickUpController,
                      decoration: InputDecoration(labelText: 'Pick Up'),
                    ),
                    TextFormField(
                      controller: _dropOffController,
                      decoration: InputDecoration(labelText: 'Drop Off'),
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(labelText: 'Date'),
                    ),
                    TextFormField(
                      controller: _cargoTypeController,
                      decoration: InputDecoration(labelText: 'Cargo Type'),
                    ),
                    TextFormField(
                      controller: _cargoOwnerController,
                      decoration: InputDecoration(labelText: 'Cargo Owner'),
                    ),
                    TextFormField(
                      controller: _packagingController,
                      decoration: InputDecoration(labelText: 'Packaging'),
                    ),
                    TextFormField(
                      controller: _weightController,
                      decoration: InputDecoration(labelText: 'Weight'),
                    ),
                    TextFormField(
                      controller: _statusController,
                      decoration: InputDecoration(labelText: 'Status'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final cargo = MyCargo.Cargo(
                      id: 0,
                      pickUp: _pickUpController.text,
                      dropOff: _dropOffController.text,
                      date: _dateController.text,
                      cargoType: _cargoTypeController.text,
                      cargoOwner: _cargoOwnerController.text,
                      packaging: _packagingController.text,
                      weight: _weightController.text,
                      status: _statusController.text,
                    );
                    BlocProvider.of<DataBloc>(context)
                        .add(PostCargoEvent(cargo as Cargo));
                    Navigator.of(context).pop();
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
