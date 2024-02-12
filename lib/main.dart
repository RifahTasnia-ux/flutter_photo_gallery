import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhotoGalleryScreen(),
    );
  }
}

class PhotoGalleryScreen extends StatefulWidget {
  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  List<dynamic> _photos = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
      if (response.statusCode == 200) {
        setState(() {
          _photos = json.decode(response.body);
        });
      } else {
        setState(() {
          _error = 'Failed to load photos';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to connect to the server';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery App'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text(_error))
          : ListView.builder(
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                final photo = _photos[index];
                return ListTile(
                  leading: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Image.network(
                        photo['thumbnailUrl'],
                        width: 50,
                        height: 150,
                        fit: BoxFit.cover,
                     ),
                  ),
                title: Text(
                  photo['title'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                 Navigator.push(
                 context,
                 MaterialPageRoute(
                  builder: (context) => PhotoDetailScreen(photo: photo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class PhotoDetailScreen extends StatelessWidget {
  final dynamic photo;

  const PhotoDetailScreen({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(photo['url']),
            SizedBox(height: 16),
            Text(
              'Title: ${photo['title']}',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'ID: ${photo['id']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
