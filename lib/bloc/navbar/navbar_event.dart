abstract class NavbarEvent {}

class MoveTo extends NavbarEvent {
  int index;
  MoveTo(this.index);
}
