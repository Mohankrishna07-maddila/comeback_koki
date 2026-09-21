-- ==============================================================================
-- Supabase Storage Setup for Private GitHub Deployment
-- ==============================================================================
-- This SQL script sets up a public Supabase Storage bucket for your media files
-- so that images/videos are served directly from Supabase CDN rather than GitHub.
-- ==============================================================================

-- 1. Create the 'memories' bucket in Supabase Storage (if it doesn't already exist)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'memories',
    'memories',
    true,
    52428800, -- 50MB max file size
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'video/mp4']
)
ON CONFLICT (id) DO UPDATE SET
    public = true,
    file_size_limit = 52428800,
    allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'video/mp4'];

-- 2. Allow public read access to all files inside the 'memories' bucket
DROP POLICY IF EXISTS "Allow public read access on memories bucket" ON storage.objects;
CREATE POLICY "Allow public read access on memories bucket"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'memories');

-- 3. Allow authenticated users or service role to upload files
DROP POLICY IF EXISTS "Allow authenticated uploads on memories bucket" ON storage.objects;
CREATE POLICY "Allow authenticated uploads on memories bucket"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'memories');

-- 4. Allow authenticated users to update/overwrite files
DROP POLICY IF EXISTS "Allow authenticated updates on memories bucket" ON storage.objects;
CREATE POLICY "Allow authenticated updates on memories bucket"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'memories')
WITH CHECK (bucket_id = 'memories');

-- 5. Allow authenticated users to delete files
DROP POLICY IF EXISTS "Allow authenticated deletes on memories bucket" ON storage.objects;
CREATE POLICY "Allow authenticated deletes on memories bucket"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'memories');
