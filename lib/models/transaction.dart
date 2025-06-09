class Transaction {
  final int id;
  final String to;
  final String amount;
  final String date;
  final String description;

  Transaction(
    this.id,
    this.to,
    this.amount,
    this.date,
    this.description,
  );
}

final List<Transaction> transactions = [
  Transaction(
    1,
    'Kopsis',
    '6000',
    '29 November 2024 10:44',
    'Kantin B',
  ),
  Transaction(
    2,
    'Warung Bu Man',
    '11.000',
    '28 November 2024 10:03',
    'Kantin A',
  ),
  Transaction(
    3,
    'Kedai Bang Syen',
    '5.000',
    '26 November 2024 10:13',
    'Kereta',
  ),
  Transaction(
    4,
    'Blibli',
    '4.500.000',
    '10 Juli 2022 12:13',
    'LCD',
  ),
  Transaction(
    5,
    'Lazada',
    '2.000.000',
    '20 Juli 2022 12:13',
    'Mouse',
  ),
  Transaction(
    6,
    'Flip',
    '3.000.000',
    '23 Juli 2022 12:13',
    'Transfer',
  ),
  Transaction(
    7,
    'Tiket.com',
    '750.000',
    '4 Juli 2022 12:13',
    'Pesawat',
  ),
  Transaction(
    8,
    'Traveloka',
    '950.000',
    '12 Juli 2022 12:13',
    'Pesawat',
  ),
  Transaction(
    9,
    'Pegipegi',
    '860.000',
    '18 Juli 2022 12:13',
    'Hotel',
  ),
  Transaction(
    10,
    'Flip',
    '250.000',
    '26 Juli 2022 12:13',
    'transfer',
  ),
];