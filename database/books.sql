-- Books table for storing book information
CREATE TABLE IF NOT EXISTS books (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    description TEXT,
    cover_image_url TEXT,
    created_by UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_books_title ON books(title);
CREATE INDEX IF NOT EXISTS idx_books_author ON books(author);
CREATE INDEX IF NOT EXISTS idx_books_created_by ON books(created_by);
CREATE INDEX IF NOT EXISTS idx_books_created_at ON books(created_at);

-- Enable RLS (Row Level Security)
ALTER TABLE books ENABLE ROW LEVEL SECURITY;

-- Create policies for books
CREATE POLICY "Anyone can view non-deleted books" ON books
    FOR SELECT USING (deleted_at IS NULL);

CREATE POLICY "Authenticated users can create books" ON books
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL AND auth.uid() = created_by AND deleted_at IS NULL);

CREATE POLICY "Users can update their own non-deleted books" ON books
    FOR UPDATE USING (auth.uid() = created_by AND deleted_at IS NULL);

CREATE POLICY "Users can soft delete their own books" ON books
    FOR UPDATE USING (auth.uid() = created_by);

-- Book reviews/ratings table for storing user answers about books
CREATE TABLE IF NOT EXISTS book_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    book_id UUID REFERENCES books(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    is_christian_content BOOLEAN,
    has_bad_words BOOLEAN,
    has_violent_content BOOLEAN,
    has_mature_themes BOOLEAN,
    is_suitable_for_all_ages BOOLEAN,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    UNIQUE(book_id, user_id)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_book_reviews_book_id ON book_reviews(book_id);
CREATE INDEX IF NOT EXISTS idx_book_reviews_user_id ON book_reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_book_reviews_created_at ON book_reviews(created_at);

-- Enable RLS (Row Level Security)
ALTER TABLE book_reviews ENABLE ROW LEVEL SECURITY;

-- Create policies for book_reviews
CREATE POLICY "Anyone can view book reviews" ON book_reviews
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can create book reviews" ON book_reviews
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL AND auth.uid() = user_id);

CREATE POLICY "Users can update their own book reviews" ON book_reviews
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own book reviews" ON book_reviews
    FOR DELETE USING (auth.uid() = user_id);

-- Function to update updated_at timestamp on books
CREATE OR REPLACE FUNCTION update_books_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    SET search_path = public, pg_temp;
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at on books
CREATE TRIGGER update_books_updated_at
    BEFORE UPDATE ON books
    FOR EACH ROW EXECUTE FUNCTION update_books_updated_at();

-- Function to update updated_at timestamp on book_reviews
CREATE OR REPLACE FUNCTION update_book_reviews_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    SET search_path = public, pg_temp;
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at on book_reviews
CREATE TRIGGER update_book_reviews_updated_at
    BEFORE UPDATE ON book_reviews
    FOR EACH ROW EXECUTE FUNCTION update_book_reviews_updated_at();

-- Function to get aggregated book data with review statistics
CREATE OR REPLACE FUNCTION get_books_with_stats(
    search_query TEXT DEFAULT NULL,
    author_filter TEXT DEFAULT NULL,
    limit_count INTEGER DEFAULT 50,
    offset_count INTEGER DEFAULT 0
)
RETURNS TABLE (
    id UUID,
    title TEXT,
    author TEXT,
    description TEXT,
    cover_image_url TEXT,
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    review_count BIGINT,
    avg_rating NUMERIC,
    christian_content_percentage NUMERIC,
    no_bad_words_percentage NUMERIC,
    no_violent_content_percentage NUMERIC,
    no_mature_themes_percentage NUMERIC,
    suitable_for_all_ages_percentage NUMERIC
) AS $$
BEGIN
    SET search_path = public, pg_temp;
    
    RETURN QUERY
    SELECT 
        b.id,
        b.title,
        b.author,
        b.description,
        b.cover_image_url,
        b.created_by,
        b.created_at,
        b.updated_at,
        COUNT(DISTINCT br.id) as review_count,
        ROUND(AVG(br.rating), 2) as avg_rating,
        ROUND(
            (COUNT(DISTINCT CASE WHEN br.is_christian_content = true THEN br.id END)::NUMERIC / 
            NULLIF(COUNT(DISTINCT CASE WHEN br.is_christian_content IS NOT NULL THEN br.id END), 0)) * 100,
            2
        ) as christian_content_percentage,
        ROUND(
            (COUNT(DISTINCT CASE WHEN br.has_bad_words = false THEN br.id END)::NUMERIC / 
            NULLIF(COUNT(DISTINCT CASE WHEN br.has_bad_words IS NOT NULL THEN br.id END), 0)) * 100,
            2
        ) as no_bad_words_percentage,
        ROUND(
            (COUNT(DISTINCT CASE WHEN br.has_violent_content = false THEN br.id END)::NUMERIC / 
            NULLIF(COUNT(DISTINCT CASE WHEN br.has_violent_content IS NOT NULL THEN br.id END), 0)) * 100,
            2
        ) as no_violent_content_percentage,
        ROUND(
            (COUNT(DISTINCT CASE WHEN br.has_mature_themes = false THEN br.id END)::NUMERIC / 
            NULLIF(COUNT(DISTINCT CASE WHEN br.has_mature_themes IS NOT NULL THEN br.id END), 0)) * 100,
            2
        ) as no_mature_themes_percentage,
        ROUND(
            (COUNT(DISTINCT CASE WHEN br.is_suitable_for_all_ages = true THEN br.id END)::NUMERIC / 
            NULLIF(COUNT(DISTINCT CASE WHEN br.is_suitable_for_all_ages IS NOT NULL THEN br.id END), 0)) * 100,
            2
        ) as suitable_for_all_ages_percentage
    FROM books b
    LEFT JOIN book_reviews br ON b.id = br.book_id
    WHERE 
        b.deleted_at IS NULL
        AND (search_query IS NULL OR b.title ILIKE CONCAT('%', search_query, '%') OR b.author ILIKE CONCAT('%', search_query, '%'))
        AND (author_filter IS NULL OR b.author ILIKE CONCAT('%', author_filter, '%'))
    GROUP BY b.id, b.title, b.author, b.description, b.cover_image_url, b.created_by, b.created_at, b.updated_at
    ORDER BY b.created_at DESC
    LIMIT limit_count
    OFFSET offset_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get unique authors
CREATE OR REPLACE FUNCTION get_unique_authors()
RETURNS TABLE (
    author TEXT
) AS $$
BEGIN
    SET search_path = public, pg_temp;
    
    RETURN QUERY
    SELECT DISTINCT b.author
    FROM books b
    WHERE b.deleted_at IS NULL
    ORDER BY b.author ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permissions on functions
GRANT EXECUTE ON FUNCTION get_books_with_stats TO authenticated;
GRANT EXECUTE ON FUNCTION get_unique_authors TO authenticated;
