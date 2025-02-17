import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_english_story/common/constants/firestore_fieldnames/vocab_firestore_fieldname.dart';
import '../../common/extensions/string/maybe_empty.dart';
import '../../common/extensions/string/to_enum.dart';
import '../../common/enums/vocab_category.dart';

class Vocab {
  final VocabCategory vocabCategory;
  final String meaning;
  final String prompt;
  final String vocabId;
  final String? vocabImgRrl;
  final String? docId;

  Vocab({
    required this.vocabCategory,
    required this.meaning,
    required this.prompt,
    required this.vocabId,
    required this.vocabImgRrl,
    this.docId,
  });

  Map<String, dynamic> toMap(){
    return {
      vocabCategoryFieldName: vocabCategory.name,
      vocabMeaningFieldName: meaning,
      vocabPromptFieldName: prompt,
      vocabIdFieldName: vocabId,
      vocabImageUrlFieldName:  vocabImgRrl,
    };
  }

  factory Vocab.fromSnapshot(
          QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Vocab(
        meaning: MaybeEmpty(snapshot.data()[vocabMeaningFieldName]).maybeEmpty(),
        prompt: MaybeEmpty(snapshot.data()[vocabPromptFieldName]).maybeEmpty(),
        vocabCategory:
            ToVocabCategory(MaybeEmpty(snapshot.data()[vocabCategoryFieldName]).maybeEmpty()).toVocabCategory(),
        vocabId: MaybeEmpty(snapshot.data()[vocabIdFieldName]).maybeEmpty(),
        vocabImgRrl: snapshot.data()[vocabImageUrlFieldName],
        docId: snapshot.id,
      );

  factory Vocab.fromDocSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
      throw Exception();
    }
        final Map snapshotData = snapshot.data()!;
    return Vocab(
        meaning: MaybeEmpty(snapshotData[vocabMeaningFieldName]).maybeEmpty(),
        prompt: MaybeEmpty(snapshotData[vocabPromptFieldName]).maybeEmpty(),
        vocabCategory:
            ToVocabCategory(MaybeEmpty(snapshotData[vocabCategoryFieldName]).maybeEmpty()).toVocabCategory(),
        vocabId: MaybeEmpty(snapshotData[vocabIdFieldName]).maybeEmpty(),
        vocabImgRrl: snapshotData[vocabImageUrlFieldName],
        docId: snapshot.id,
      );
  }

  factory Vocab.fromMap(
          Map<String, dynamic> map) =>
      Vocab(
        meaning: MaybeEmpty(map[vocabMeaningFieldName]).maybeEmpty(),
        prompt: MaybeEmpty(map[vocabPromptFieldName]).maybeEmpty(),
        vocabCategory:
            MaybeEmpty(map[vocabCategoryFieldName]).maybeEmpty().toVocabCategory(),
        vocabId: MaybeEmpty(map[vocabIdFieldName]).maybeEmpty(),
        vocabImgRrl: map[vocabImageUrlFieldName],
      );
}
