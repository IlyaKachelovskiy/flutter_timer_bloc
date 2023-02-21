
///Ticker предоставляет функцию тиков, которая принимает нужное нам количество
///тиков (секунд) и возвращает поток, который каждую секунду тикает оставшиеся секунды.
    
class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
