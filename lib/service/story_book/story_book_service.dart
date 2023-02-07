import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_english_story/domain/models/study_page.dart';
import 'package:my_english_story/domain/models/story_book.dart';
import 'package:my_english_story/domain/models/quiz.dart';
import 'package:my_english_story/service/story_book/firebase_story_book_provider.dart';
import '../../common/enums/vocab_category.dart';
import '../../common/extensions/string/split_containing_patterns.dart';

import 'story_book_provider.dart';

class StoryBookService implements StoryBookProvider{
  final StoryBookProvider provider;
  const StoryBookService(this.provider);

  factory StoryBookService.firebase() => StoryBookService(FirebaseStoryBookProvider());

  List<dynamic> getTokens({required String inputString, RegExp? regex}){
    final result = SplitContainingPatterns(inputString).splitContainingPatterns(pattern: regex ?? RegExp(r'(#)|(@)'), shouldTrim: true).map((e) {
      if(e == "#"){
        return VocabCategory.noun;
      } else if(e == "@"){
        return VocabCategory.verb;
      } else{
        return e;
      }
    }).toList();
    return result;
  }

  Iterable<Widget> convertQuestionsToWidgets({required String question}){
    return getTokens(inputString: question).map((e) {
      if(e.runtimeType == VocabCategory){
        return Container(color: Colors.amber, child: Text("[Fill here - ${e.toString()}]"));
      } else{
        return Container(child: Text(e));
      }
    });
  }

  Widget test(BuildContext context){
    return RichText(
      text: TextSpan(
        text: 'Hello ',
        style: DefaultTextStyle.of(context).style,
        children: const <TextSpan>[
          TextSpan(text: 'bold', style: TextStyle(fontWeight: FontWeight.bold) ),
          TextSpan(text: ' world!'),
        ],
      ),
    );
  }

  @override
  Stream<Iterable<Quiz>> getQuizPagesByPageOrder({required String docId}) => provider.getQuizPagesByPageOrder(docId: docId);

  @override
  Stream<Iterable<StoryBook>> getStoryBooksByLevel({int level = 1}) => provider.getStoryBooksByLevel(level: level);

  @override
  Stream<Iterable<StudyPage>> getStudyPagesByPageOrder({required String docId}) => provider.getStudyPagesByPageOrder(docId: docId);  
}