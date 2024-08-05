abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<String> favorites;

  FavoriteLoaded(this.favorites);
}
