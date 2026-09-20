-- Table: messages
-- Stores conversation messages exchanged between husband and wife

CREATE TABLE IF NOT EXISTS messages (
    id BIGSERIAL PRIMARY KEY,
    sender VARCHAR(10) NOT NULL CHECK (sender IN ('husband', 'wife')),
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN NOT NULL DEFAULT FALSE
);

-- Index to optimize querying messages in chronological order
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages (created_at ASC);

-- Row Level Security (RLS) setup for messages
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read access" ON messages FOR SELECT USING (true);
CREATE POLICY "Allow public insert access" ON messages FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update access" ON messages FOR UPDATE USING (true) WITH CHECK (true);

-- Table: call_signals
-- Handles WebRTC peer-to-peer audio/video call signaling and real-time typing indicators
CREATE TABLE IF NOT EXISTS call_signals (
    id BIGSERIAL PRIMARY KEY,
    caller VARCHAR(10) NOT NULL CHECK (caller IN ('husband', 'wife')),
    callee VARCHAR(10) NOT NULL CHECK (callee IN ('husband', 'wife')),
    call_type VARCHAR(10) NOT NULL DEFAULT 'audio', -- 'audio', 'video', 'text'
    signal_type VARCHAR(20) NOT NULL, -- 'offer', 'answer', 'candidate', 'hangup', 'reject', 'typing'
    data TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_call_signals_callee ON call_signals (callee, created_at ASC);

-- Row Level Security (RLS) setup for call_signals
ALTER TABLE call_signals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read signals" ON call_signals FOR SELECT USING (true);
CREATE POLICY "Allow public insert signals" ON call_signals FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete signals" ON call_signals FOR DELETE USING (true);

