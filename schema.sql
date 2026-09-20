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

-- Row Level Security (RLS) setup for Supabase
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Allow reading messages
CREATE POLICY "Allow public read access" ON messages
    FOR SELECT
    USING (true);

-- Allow inserting messages
CREATE POLICY "Allow public insert access" ON messages
    FOR INSERT
    WITH CHECK (true);
