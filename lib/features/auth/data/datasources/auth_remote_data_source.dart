import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voldt/core/error/exception.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  );
  Future<String> logInWithEmailAndPassword(
    String email,
    String password,
  );
}

class AuthRemoteDataSourceImpl
    implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> logInWithEmailAndPassword(
    String email,
    String password,
  ) {
    // TODO: implement logInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<String> signUpWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerException('User is null');
      }
      return response.user!.id;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
