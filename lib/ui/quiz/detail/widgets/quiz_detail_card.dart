import 'package:flutter/material.dart';
import 'package:quiz/data/models/quiz_detail_model.dart';
import 'package:quiz/ui/common/widgets/loading_widget.dart';
import 'package:quiz/core/theme/responsive/layout.dart';

class QuizDetailCard extends StatelessWidget {
  final QuizDetailModel detail;
  const QuizDetailCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD57E7E),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        margin: EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            renderStars(),
            const SizedBox(height: 16),

            /// 이미지 링크가 있으면 이미지를 보여준다
            if (detail.imgUrl != null && detail.imgUrl!.isNotEmpty)
              Expanded(child: _ImageBox(imgUrl: detail.imgUrl!)),

            /// 질문이 있다면 질문을 UI에 보여준다
            if (detail.question != null)
              Expanded(
                child: _QuestionBox(question: detail.question!),
              ),
          ],
        ),
      ),
    );
  }

  ///---------------------------------------------------------------------------
  Widget renderStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Stack(
          children: [
            Icon(
              Icons.star_border,
              size: 40,
              color: Colors.white, // 테두리 색상
            ),
            Icon(
              Icons.star,
              size: 40,
              color: index + 1 > detail.level
                  ? Colors.transparent
                  : Colors.yellow, // 내부 색상
            ),
          ],
        );
      }),
    );
  }
}

class _ImageBox extends StatelessWidget {
  final String imgUrl;
  const _ImageBox({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imgUrl,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return SizedBox(height: 300, child: LoadingWidget());
      },
      errorBuilder: (context, error, stackTrace) {
        return Text(
          '사진을 불러올 수 없습니다.',
          style: TextStyle(fontSize: 18, color: Colors.white),
        );
      },
    );
  }
}

class _QuestionBox extends StatelessWidget {
  final String question;
  const _QuestionBox({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(
          'Q.$question',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.layout(36, mobile: 24),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
