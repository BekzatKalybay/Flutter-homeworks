void main() {
  // Установка различных тарифов за километр
  final double firstRate = 250; // До 10 км
  final double secondRate = 200; // От 10 до 20 км
  final double thirdRate = 150; // Свыше 20 км

  // Коэффициенты для тарифного плана
  final int economyCoefficient = 1;
  final int standardCoefficient = 2;
  final int premiumCoefficient = 3;

  double distanceTraveled = 25; // Пройденное расстояние
  double totalCost = 0; // Общая стоимость поездки

  // Применение соответствующего тарифа в зависимости от пройденного расстояния
  switch (distanceTraveled) {
    case double.infinity:
      totalCost = distanceTraveled * thirdRate * premiumCoefficient;
      break;
    default:
      if (distanceTraveled > 20) {
        totalCost = (10 * firstRate + 10 * secondRate + (distanceTraveled - 20) * thirdRate) * premiumCoefficient;
      } else if (distanceTraveled > 10) {
        totalCost = (10 * firstRate + (distanceTraveled - 10) * secondRate) * standardCoefficient;
      } else {
        totalCost = distanceTraveled * firstRate * economyCoefficient;
      }
  }

  // Вывод итоговой стоимости и пройденного расстояния
  print('Итоговая стоимость: $totalCost тенге за $distanceTraveled км');
}