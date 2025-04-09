import 'package:powersync/powersync.dart';

/// The schema of the database.
const schema = Schema([
  Table(
    'bets',
    [
      Column.text('created_at'),
      Column.text('choice_id'),
      Column.text('user_id'),
      Column.integer('amount'),
      Column.text('status'),
    ],
    indexes: [
      Index('choice', [IndexedColumn('choice_id')]),
      Index('user', [IndexedColumn('user_id')]),
    ],
  ),
  Table(
    'challenges',
    [
      Column.text('created_at'),
      Column.text('title'),
      Column.text('question'),
      Column.text('starting'),
      Column.text('ending'),
      Column.text('creator_id'),
      Column.text('limit_date'),
      Column.integer('has_bet'),
      Column.integer('min_bet'),
      Column.integer('max_bet'),
      Column.integer('amount'),
    ],
    indexes: [
      Index('user', [IndexedColumn('creator_id')]),
    ],
  ),
  Table(
    'choices',
    [
      Column.text('created_at'),
      Column.text('challenge_id'),
      Column.text('value'),
      Column.integer('is_correct'),
    ],
    indexes: [
      Index('challenge', [IndexedColumn('challenge_id')]),
    ],
  ),
  Table(
    'participants',
    [
      Column.text('created_at'),
      Column.text('user_id'),
      Column.text('challenge_id'),
      Column.text('status'),
    ],
    indexes: [
      Index('user', [IndexedColumn('user_id')]),
      Index('challenge', [IndexedColumn('challenge_id')]),
    ],
  ),
  Table(
    'users',
    [
      Column.text('created_at'),
      Column.text('email'),
      Column.text('username'),
      Column.text('avatar_url'),
      Column.text('push_token'),
      Column.text('full_name'),
    ],
  ),
  Table(
    'friendships',
    [
      Column.text('sender_id'),
      Column.text('created_at'),
      Column.text('receiver_id'),
    ],
    indexes: [
      Index('sender', [IndexedColumn('sender_id')]),
      Index('receiver', [IndexedColumn('receiver_id')]),
    ],
  ),
  Table(
    'notifications',
    [
      Column.text('created_at'),
      Column.text('user_id'),
      Column.text('title'),
      Column.text('body'),
      Column.text('status'),
      Column.text('type'),
      Column.text('metadatas'),
    ],
    indexes: [
      Index('user', [IndexedColumn('user_id')]),
    ],
  ),
  Table(
    'wallets',
    [
      Column.text('created_at'),
      Column.text('user_id'),
      Column.integer('amount'),
    ],
    indexes: [
      Index('user', [IndexedColumn('user_id')]),
    ],
  ),
  Table(
    'transactions',
    [
      Column.text('created_at'),
      Column.text('sender_id'),
      Column.text('receiver_id'),
      Column.integer('amount'),
      Column.text('origin_id'),
      Column.text('status'),
    ],
    indexes: [
      Index('receiver', [IndexedColumn('receiver_id')]),
      Index('sender', [IndexedColumn('sender_id')]),
      Index('origin', [IndexedColumn('origin_id')]),
    ],
  ),
]);
