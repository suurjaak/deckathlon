CREATE TABLE IF NOT EXISTS users (
  id         INTEGER   PRIMARY KEY AUTOINCREMENT NOT NULL,
  username   TEXT      NOT NULL CHECK (LENGTH(username) > 0),
  password   TEXT      NOT NULL CHECK (LENGTH(password) > 0),
  dt_created TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_changed TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now'))
);


CREATE TABLE IF NOT EXISTS games (
  id         INTEGER   PRIMARY KEY AUTOINCREMENT NOT NULL,
  fk_table   INTEGER   NOT NULL REFERENCES tables (id),
  fk_player  INTEGER   REFERENCES players (id),
  sequence   INTEGER   NOT NULL DEFAULT 0,
  status     TEXT      NOT NULL DEFAULT 'new',
  opts       JSON      NOT NULL DEFAULT '{}',
  deck       JSON      NOT NULL DEFAULT '[]',
  hands      JSON      NOT NULL DEFAULT '{}',
  talon      JSON      NOT NULL DEFAULT '[]',
  talon0     JSON      NOT NULL DEFAULT '[]',
  bids       JSON      NOT NULL DEFAULT '[]',
  bid        JSON      NOT NULL DEFAULT '{}',
  tricks     JSON      NOT NULL DEFAULT '[]',
  trick      JSON      NOT NULL DEFAULT '[]',
  moves      JSON      DEFAULT '[]',
  discards   JSON      NOT NULL DEFAULT '[]',
  score      JSON      NOT NULL DEFAULT '{}',
  dt_created TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_changed TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now'))
);


CREATE TABLE IF NOT EXISTS log (
  id         INTEGER   PRIMARY KEY AUTOINCREMENT NOT NULL,
  fk_user    INTEGER   REFERENCES users (id),
  action     TEXT,
  data       JSON,
  dt_created TIMESTAMP DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now'))
);


CREATE TABLE IF NOT EXISTS online (
  id         INTEGER   PRIMARY KEY AUTOINCREMENT NOT NULL,
  fk_user    INTEGER   NOT NULL REFERENCES users (id),
  fk_table   INTEGER   REFERENCES tables (id),
  active     INTEGER   NOT NULL DEFAULT 1,
  dt_online  TIMESTAMP DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_created TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_changed TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  UNIQUE (fk_user, fk_table)
);


CREATE TABLE IF NOT EXISTS players (
  id         INTEGER   PRIMARY KEY AUTOINCREMENT NOT NULL,
  fk_table   INTEGER   NOT NULL REFERENCES tables (id),
  fk_game    INTEGER   REFERENCES games (id),
  fk_user    INTEGER   NOT NULL REFERENCES users (id),
  sequence   INTEGER   NOT NULL DEFAULT 0,
  status     TEXT,
  expected   JSON      DEFAULT '{}',
  hand       JSON      NOT NULL DEFAULT '[]',
  hand0      JSON      NOT NULL DEFAULT '[]',
  moves      JSON      NOT NULL DEFAULT '[]',
  tricks     JSON      NOT NULL DEFAULT '[]',
  dt_created TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_changed TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_deleted TIMESTAMP
);


CREATE TABLE IF NOT EXISTS table_users (
  id         INTEGER   PRIMARY KEY AUTOINCREMENT NOT NULL,
  fk_table   INTEGER   NOT NULL REFERENCES tables (id),
  fk_user    INTEGER   NOT NULL REFERENCES users (id),
  dt_created TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_changed TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_deleted TIMESTAMP
);


CREATE TABLE IF NOT EXISTS tables (
  id             INTEGER   PRIMARY KEY AUTOINCREMENT NOT NULL,
  fk_creator     INTEGER   NOT NULL REFERENCES users (id),
  fk_host        INTEGER   NOT NULL REFERENCES users (id),
  fk_template    INTEGER   NOT NULL REFERENCES templates (id),
  name           TEXT      NOT NULL,
  shortid        TEXT      NOT NULL UNIQUE,
  public         INTEGER   NOT NULL DEFAULT 0,
  games          INTEGER   NOT NULL DEFAULT 0,
  players        INTEGER   NOT NULL DEFAULT 0,
  status         TEXT      DEFAULT 'new',
  bids           JSON      NOT NULL DEFAULT '[]',
  scores         JSON      NOT NULL DEFAULT '[]',
  bids_history   JSON      NOT NULL DEFAULT '[]',
  scores_history JSON      NOT NULL DEFAULT '[]',
  dt_created     TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_changed     TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now'))
);


CREATE TABLE IF NOT EXISTS templates (
  id         INTEGER   PRIMARY KEY AUTOINCREMENT NOT NULL,
  fk_creator INTEGER   REFERENCES users (id),
  name       TEXT      NOT NULL UNIQUE CHECK (LENGTH(name) > 0),
  opts       JSON      NOT NULL DEFAULT '{}',
  dt_created TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_changed TIMESTAMP NOT NULL DEFAULT (STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now')),
  dt_deleted TIMESTAMP
);


CREATE TRIGGER IF NOT EXISTS on_update_games AFTER UPDATE ON games
BEGIN
UPDATE games SET dt_changed = STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now') WHERE id = NEW.id;
END;


CREATE TRIGGER IF NOT EXISTS on_update_online AFTER UPDATE ON online
BEGIN
UPDATE online SET dt_changed = STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now') WHERE id = NEW.id;
END;


CREATE TRIGGER IF NOT EXISTS on_update_players AFTER UPDATE ON players
BEGIN
UPDATE players SET dt_changed = STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now') WHERE id = NEW.id;
END;


CREATE TRIGGER IF NOT EXISTS on_update_tables AFTER UPDATE ON tables
BEGIN
UPDATE tables SET dt_changed = STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now') WHERE id = NEW.id;
END;


CREATE TRIGGER IF NOT EXISTS on_update_templates AFTER UPDATE ON templates
BEGIN
UPDATE templates SET dt_changed = STRFTIME('%Y-%m-%d %H:%M:%fZ', 'now') WHERE id = NEW.id;
END;


INSERT OR IGNORE INTO users (id, username, password) VALUES (1, 'admin', '0fb57789d87a97f7949ab902b3f2d8001acb6ddea7b4fc0b46a4681124245f4e');

INSERT OR IGNORE INTO templates (id, fk_creator, name, opts, dt_created, dt_changed) VALUES (1, 1, 'Tuhat', X'7B0A20202020226361726473223A20202020205B223944222C20223948222C20223953222C20223943222C20224A44222C20224A48222C20224A53222C20224A43222C20225144222C20225148222C20225153222C20225143222C20224B44222C20224B48222C20224B53222C20224B43222C20223044222C20223048222C20223053222C20223043222C20224144222C20224148222C20224153222C20224143225D2C0A2020202022737472656E67746873223A2022394A514B3041222C0A2020202022737569746573223A202020202244485343222C0A2020202022706C6179657273223A2020205B332C20345D2C0A202020202268616E64223A202020202020372C0A2020202022736F7274223A2020202020205B227375697465222C2022737472656E677468225D2C0A0A202020202274616C6F6E223A202020207B0A20202020202020202266616365223A2020202020202066616C73650A202020207D2C0A2020202022747269636B223A20202020747275652C0A20202020227472756D70223A20202020747275652C0A202020202262696464696E67223A2020202020207B0A2020202020202020226D696E223A20202020202020202036302C0A2020202020202020226D6178223A2020202020202020203334302C0A20202020202020202273746570223A2020202020202020352C0A20202020202020202270617373223A2020202020202020747275652C0A202020202020202022706173735F66696E616C223A2020747275652C0A20202020202020202274616C6F6E223A20202020202020747275652C0A20202020202020202261667465726D61726B6574223A20747275652C0A20202020202020202264697374726962757465223A2020747275652C0A202020202020202022626C696E64223A20202020202020747275650A202020207D2C0A0A20202020226C656164223A20202020207B0A20202020202020202230223A2020202022626964646572222C0A2020202020202020222A223A2020202022747269636B220A202020207D2C0A20202020226D6F7665223A20202020207B0A2020202020202020226361726473223A2020312C0A20202020202020202270617373223A2020202066616C73652C0A202020202020202022637261776C223A202020302C0A202020202020202022726573706F6E7365223A20207B0A20202020202020202020227375697465223A202020747275650A20202020202020207D2C0A2020202020202020227370656369616C223A20207B0A20202020202020202020227472756D70223A2020207B0A2020202020202020202020202230223A2066616C73652C0A202020202020202020202020222A223A205B5B224B44222C20225144225D2C205B224B48222C20225148225D2C205B224B53222C20225153225D2C205B224B43222C20225143225D5D0A202020202020202020207D2C0A2020202020202020202022776865656C73223A2020207B0A20202020202020202020202022636F6E646974696F6E223A20227472756D70222C0A2020202020202020202020202230223A20202020202020202066616C73652C0A202020202020202020202020222A223A2020202020202020205B5B224144222C20223044225D2C205B224148222C20223048225D2C205B224153222C20223053225D2C205B224143222C20223043225D5D0A202020202020202020207D0A20202020202020207D2C0A20202020202020202277696E223A207B0A20202020202020202020227375697465223A20747275652C0A20202020202020202020226C6576656C223A20747275650A20202020202020207D0A202020207D2C0A0A2020202022706F696E7473223A207B0A20202020202022747269636B223A207B2239223A20302C202230223A2031302C20224A223A20322C202251223A20332C20224B223A20342C202241223A2031317D2C0A202020202020227472756D70223A207B0A20202020202020202244223A202034302C0A20202020202020202248223A202036302C0A20202020202020202253223A202038302C0A20202020202020202243223A203130300A2020202020207D2C0A20202020202022776865656C73223A203132302C0A2020202020202270656E616C74696573223A207B0A202020202020202022626C696E64223A20207B226F70223A20226D756C222C202276616C7565223A202D327D2C0A202020202020202022626964223A202020207B226F70223A20226D756C222C202276616C7565223A202D317D2C0A2020202020202020226E6F6368616E6765223A207B2274696D6573223A20332C20226F70223A2022616464222C202276616C7565223A202D3130307D0A2020202020207D2C0A202020202020226269646F6E6C79223A207B226D696E223A203930307D0A202020207D2C0A0A2020202022636F6D706C657465223A207B0A2020202020202273636F7265223A20313030300A202020207D2C0A0A20202020226F72646572223A20202020747275652C0A202020202270617373223A202020202066616C73652C0A202020202272656465616C223A2020207B0A20202020202020202272657665616C223A202020202020747275650A202020207D2C0A202020202272657665616C223A202020747275650A7D', '2020-04-18 22:07:23.000000Z', '2020-05-03 18:01:29.635000Z');

INSERT OR IGNORE INTO templates (id, fk_creator, name, opts, dt_created, dt_changed) VALUES (2, 1, 'Arschloch', X'7B0A20202020226361726473223A2020202020205B223344222C20223348222C20223353222C20223343222C20223444222C20223448222C20223453222C20223443222C20223544222C20223548222C20223553222C20223543222C20223644222C20223648222C20223653222C20223643222C20223744222C20223748222C20223753222C20223743222C20223844222C20223848222C20223853222C20223843222C20223944222C20223948222C20223953222C20223943222C20224A44222C20224A48222C20224A53222C20224A43222C20225144222C20225148222C20225153222C20225143222C20224B44222C20224B48222C20224B53222C20224B43222C20223044222C20223048222C20223053222C20223043222C20224144222C20224148222C20224153222C20224143222C20223244222C20223248222C20223253222C20223243222C202258222C202258222C202258225D2C0A2020202022737472656E67746873223A20202233343536373839304A514B413258222C0A2020202022706C6179657273223A202020205B332C20375D2C0A202020202268616E64223A2020202020202031392C0A2020202022736F7274223A2020202020202022737472656E677468222C0A0A2020202022737461636B223A202020202020747275652C0A20202020226F72646572223A202020202020747275652C0A20202020226469736361726473223A202020747275652C0A202020202272657665616C223A20202020202020747275652C0A0A20202020226C656164223A202020202020207B0A20202020202020202230223A20202020202020202020207B2272616E6B696E67223A202D317D2C0A2020202020202020222A223A202020202020202020202022747269636B220A202020207D2C0A0A20202020226D6F7665223A20202020207B0A2020202020202020226361726473223A2020222A222C0A2020202020202020226C6576656C223A20747275652C0A20202020202020202270617373223A2020747275652C0A202020202020202022726573706F6E7365223A207B0A202020202020202020202020226C6576656C223A2020747275652C0A20202020202020202020202022616D6F756E74223A20747275650A20202020202020207D2C0A20202020202020202277696E223A207B0A20202020202020202020226C617374223A2020747275652C0A20202020202020202020226C6576656C223A2022616C6C220A20202020202020207D0A202020207D2C0A0A202020202272616E6B696E67223A207B0A20202020202020202266696E697368223A20747275650A202020207D2C0A0A20202020226E65787467616D65223A207B0A20202020202020202264697374726962757465223A207B0A2020202020202020202020202272616E6B696E67223A20747275652C0A202020202020202020202020226D6178223A2020202020330A20202020202020207D0A202020207D0A0A7D', '2020-05-03 19:46:23.843000Z', '2020-05-06 19:10:13.930000Z');
