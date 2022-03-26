import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'commentservice.dart';
import 'here_service.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => PostService()),
//         ChangeNotifierProvider(create: (context) => CommentService()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomePage(),
//     );
//   }
// }

class Post {
  String postTitle;
  String postContent;
  List<Comment> comments;
  Post(this.postTitle, this.postContent, this.comments);
}

class Comment {
  late String commentId;
  late String commentContent;
  Comment(this.commentId, this.commentContent);
}

class HomeSecondPage extends StatelessWidget {
  final Post? post;
  const HomeSecondPage({Key? key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final hereService = context.read<HereService>();
    final user = authService.currentUser()!;

    // return Consumer<PostService>(builder: (context, postService, child) {
    return Consumer<HereService>(
      builder: (context, hereService, child) {
        // List<Post> postList = hereService.hereList;
        // List<Post> postList = hereService.hereList;
        // print(FirebaseFirestore.instance.collection('bucket').get());
        return Scaffold(
          appBar: AppBar(
            title: Text('게시판'),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('bucket').get(),
            builder: (context, snapshot) {
              final documents = snapshot.data?.docs ?? [];

              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    // var _post = postList[index];
                    var document = documents[index];
                    final doc = documents[index];

                    QueryDocumentSnapshot snapshot = documents[index];
                    Map<String, dynamic> jsonmap = jsonDecode(
                      jsonEncode(
                        snapshot.data(),
                      ),
                    );

                    return Column(
                      children: [
                        ListTile(
                          title: Text('job : ${jsonmap['job']}'),
                          subtitle: Text('uid : ${jsonmap['uid']}'),
                          leading: CircleAvatar(
                            child: Text(
                              '${user.email}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return PostDetailPage(
                                    // post: _post,
                                    post: Post('', '', []),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        Divider(thickness: 1),
                      ],
                    );
                  },
                );
              } else
                return CircularProgressIndicator();
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostPage(),
                ),
              );
            },
            child: Icon(Icons.post_add),
          ),
        );
      },
    );
  }
}

//게시글 상세조회 페이지
// class PostDetailPage extends StatelessWidget {
//   final Post post;

//   const PostDetailPage({Key? key, required this.post}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CommentService>(builder: (context, commentService, child) {
class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage({Key? key, required this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PostService>(builder: (context, postService, child) {
      //List<Comment> commentList = commentService.commentList;
      final authService = context.read<AuthService>();
      final hereService = context.read<HereService>();
      final user = authService.currentUser()!;
      return Scaffold(
        appBar: AppBar(
          title: Text('게시글 상세'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: hereService.read(user.uid),
                  builder: (context, snapshot) {
                    final documents = snapshot.data?.docs ?? [];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 48, height: 48, child: CircleAvatar(child: Text("${user.email}"))),
                            SizedBox(width: 16),
                            Text(post.postTitle, style: TextStyle(fontSize: 24)),
                            Spacer(),
                            Text(
                              'YYYY/MM/DD \n HH:MM',
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                        Divider(thickness: 2),
                        Container(height: 100, child: Text(post.postContent)),
                        Divider(thickness: 2),
                        Text(
                          '댓글 ${post.comments.length}개',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        post.comments.isEmpty
                            ? Text('아직 댓글이 없습니다.')
                            : Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: post.comments.length,
                                    //itemCount: commentList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final doc = documents[index];
                                      String job = doc.get('job');
                                      bool isDone = doc.get('isDone');

                                      var _comment = post.comments[index];
                                      return ListTile(
                                        title: Text(_comment.commentContent),
                                        leading: CircleAvatar(child: Text(_comment.commentId)),
                                        trailing: IconButton(
                                          icon: Icon(CupertinoIcons.delete),
                                          onPressed: () {
                                            // 삭제 버튼 클릭시
                                            hereService.delete(doc.id);
                                          },
                                        ),
                                      );
                                    }),
                              ),

                        //Spacer(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () => {}),
      );
    });
  }
}

//게시글 작성 페이지
class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final hereService = context.read<HereService>();
    User user = authService.currentUser()!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '작성하기',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration.collapsed(hintText: '제목을 입력하세요.'),
                ),
              ),
              Divider(thickness: 1),
              Container(
                height: 180,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration.collapsed(hintText: '내용을 입력하세요.'),
                ),
              ),
              Divider(thickness: 1),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      // String postTitle = titleController.text;
                      // String postContent = textController.text;
                      // PostService postService = context.read<PostService>();
                      // postService.createPost(postTitle, postContent);
                      // Navigator.pop(context);
                      if (jobController.text.isNotEmpty) {
                        hereService.create(jobController.text, user.uid);
                      }
                    },
                    child: Text('작성완료')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PostService extends ChangeNotifier {
  List<Post> postList = [
    //Post('제목예시', '내용예시', [Comment('User', '댓글을 남기세요.')])
  ];

  void createPost(String postTitle, String postContent) {
    postList.add(Post(postTitle, postContent, []));
    notifyListeners();
  }
}

class CommentService extends ChangeNotifier {
  List<Comment> commentList = [];

  void createComment(String commentId, String commentContent) {
    // commentList.add(Comment(commentId, commentContent));
    notifyListeners();
  }
}
