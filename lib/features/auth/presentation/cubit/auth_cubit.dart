import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dalil_alaqar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dalil_alaqar/features/auth/domain/entities/auth_response_entity.dart';
import 'package:dalil_alaqar/features/auth/domain/entities/user_entity.dart';
import 'package:dalil_alaqar/features/auth/domain/usecases/login_usecase.dart';
import 'package:dalil_alaqar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:dalil_alaqar/features/auth/presentation/cubit/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthCubit({required this.loginUseCase, required this.logoutUseCase})
    : super(AuthInitial());

  factory AuthCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final AuthRemoteDataSource remoteDataSource = AuthRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    final LoginUseCase loginUseCase = LoginUseCase(repository);
    final LogoutUseCase logoutUseCase = LogoutUseCase(repository);

    return AuthCubit(loginUseCase: loginUseCase, logoutUseCase: logoutUseCase);
  }

  Future<void> login({
    required String phoneNumber,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      phoneNumber: phoneNumber,
      password: password,
    );

    result.fold((failure) => emit(AuthFailure(failure.errMessage)), (
      authResponse,
    ) async {
      // Save token and user data to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authResponse.token);
      await prefs.setInt('user_id', authResponse.user.id);
      await prefs.setString('user_name', authResponse.user.name);
      await prefs.setString('user_email', authResponse.user.email);
      await prefs.setString('user_phone', authResponse.user.phoneNumber);
      await prefs.setBool('user_is_active', authResponse.user.isActive);
      await prefs.setStringList('user_roles', authResponse.user.roles);
      await prefs.setStringList(
        'user_permissions',
        authResponse.user.permissions,
      );
      await prefs.setBool('is_guest', false);

      emit(AuthSuccess(authResponse));
    });
  }

  Future<void> continueAsGuest() async {
    // Save guest mode to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_guest', true);
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');

    emit(AuthGuest());
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool('is_guest') ?? false;
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');
    final userName = prefs.getString('user_name');
    final userEmail = prefs.getString('user_email');
    final userPhone = prefs.getString('user_phone');
    final userIsActive = prefs.getBool('user_is_active');
    final userRoles = prefs.getStringList('user_roles') ?? [];
    final userPermissions = prefs.getStringList('user_permissions') ?? [];

    if (isGuest) {
      emit(AuthGuest());
    } else if (token != null &&
        userId != null &&
        userName != null &&
        userEmail != null &&
        userPhone != null) {
      // User is logged in - restore session
      // Create a minimal AuthResponseEntity from stored data
      final authResponse = AuthResponseEntity(
        user: UserEntity(
          id: userId,
          name: userName,
          email: userEmail,
          phoneNumber: userPhone,
          isActive: userIsActive ?? true,
          roles: userRoles,
          permissions: userPermissions,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        token: token,
      );
      emit(AuthSuccess(authResponse));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) {
        // Even if API call fails, clear local data
        _clearLocalData();
        emit(AuthInitial());
      },
      (message) {
        // API call successful, clear local data
        _clearLocalData();
        emit(AuthInitial());
      },
    );
  }

  Future<void> _clearLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
