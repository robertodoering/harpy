import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harpy/api/api.dart';
import 'package:harpy/components/components.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    this.initialUser,
    this.handle,
  }) : assert(initialUser != null || handle != null);

  final UserData? initialUser;
  final String? handle;

  static const route = 'user_profile';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserRelationshipBloc(
            handle: handle ?? initialUser!.handle,
          ),
        ),
        BlocProvider(
          create: (_) => UserProfileCubit(
            initialUser: initialUser,
            handle: handle,
          ),
        ),
      ],
      child: const _Scaffold(),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<UserProfileCubit>();
    final state = cubit.state;

    return HarpyScaffold(
      body: state.map(
        data: (data) => UserProfileContent(
          user: data.user,
        ),
        // TODO: add proper loading shimmer for user profile screen
        loading: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (_) => LoadingDataError(
          message: const Text('error loading user'),
          onRetry: cubit.requestUserData,
        ),
      ),
    );
  }
}
