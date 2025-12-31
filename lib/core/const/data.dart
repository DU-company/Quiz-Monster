import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const CATEGORIES = [
  '맞추기',
  '라이어 게임',
  '이어말하기',
  '몸으로 말해요',
  '스피드 게임',
  '기타 게임',
];

final SUPABASE_API_KEY = dotenv.env['SUPABASE_API_KEY']!;
final SUPABASE_URL = dotenv.env['SUPABASE_URL']!;
