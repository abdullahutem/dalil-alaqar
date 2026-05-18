class MainState {
  final int currentIndex;

  const MainState({required this.currentIndex});

  MainState copyWith({int? currentIndex}) {
    return MainState(currentIndex: currentIndex ?? this.currentIndex);
  }
}
