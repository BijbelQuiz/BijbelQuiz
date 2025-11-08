-- Store Items and Pricing Table
-- This table stores all items that can be purchased in the store
CREATE TABLE IF NOT EXISTS store_items (
    id SERIAL PRIMARY KEY,
    item_key TEXT UNIQUE NOT NULL,           -- Unique identifier for the item (e.g., 'double_stars_5_questions', 'oled_theme', 'ai_theme_generator')
    item_name TEXT NOT NULL,                 -- Display name of the item
    item_description TEXT NOT NULL,          -- Description of the item
    item_type TEXT NOT NULL,                 -- Type: 'powerup', 'theme', 'feature'
    icon TEXT,                               -- Icon identifier for the item
    base_price INTEGER NOT NULL DEFAULT 0,   -- Base price in stars
    current_price INTEGER NOT NULL DEFAULT 0, -- Current price in stars (can be discounted)
    is_discounted BOOLEAN DEFAULT FALSE,     -- Whether the item is currently discounted
    discount_percentage INTEGER DEFAULT 0,   -- Discount percentage (0-100)
    discount_start TIMESTAMP WITH TIME ZONE, -- Start date of discount (NULL if no discount)
    discount_end TIMESTAMP WITH TIME ZONE,   -- End date of discount (NULL if no discount)
    is_active BOOLEAN DEFAULT TRUE,          -- Whether the item is available for purchase
    category TEXT,                           -- Additional category grouping
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default store items based on the current app
INSERT INTO store_items (item_key, item_name, item_description, item_type, icon, base_price, current_price, is_discounted, discount_percentage, is_active, category) VALUES
('double_stars_5_questions', 'Dubbele Sterren', 'Verdubbel je score voor de volgende 5 vragen', 'powerup', 'Icons.flash_on_rounded', 100, 100, FALSE, 0, TRUE, 'powerups'),
('triple_stars_5_questions', 'Driedubbele Sterren', 'Verdriedubbel je score voor de volgende 5 vragen', 'powerup', 'Icons.flash_on_rounded', 180, 180, FALSE, 0, TRUE, 'powerups'),
('five_times_stars_5_questions', '5x Sterren', 'Verhoog je score 5x voor de volgende 5 vragen', 'powerup', 'Icons.flash_on_rounded', 350, 350, FALSE, 0, TRUE, 'powerups'),
('double_stars_60_seconds', 'Dubbele Sterren (60s)', 'Verdubbel je score voor de volgende 60 seconden', 'powerup', 'Icons.timer_rounded', 120, 120, FALSE, 0, TRUE, 'powerups'),
('oled_theme', 'OLED Thema', 'Optimaliseer voor OLED schermen met pure zwarte achtergronden', 'theme', 'Icons.nights_stay_rounded', 150, 150, FALSE, 0, TRUE, 'themes'),
('green_theme', 'Groen Thema', 'Een kalmerend groen thema voor een rustige ervaring', 'theme', 'Icons.eco_rounded', 120, 120, FALSE, 0, TRUE, 'themes'),
('orange_theme', 'Oranje Thema', 'Een levendig oranje thema voor een energieke ervaring', 'theme', 'Icons.circle_rounded', 120, 120, FALSE, 0, TRUE, 'themes'),
('ai_theme_generator', 'AI Thema Generator', 'Genereer je eigen unieke thema met AI-technologie', 'feature', 'Icons.smart_toy_rounded', 200, 200, FALSE, 0, TRUE, 'features');

-- Update base prices to match current store prices
UPDATE store_items SET 
    base_price = CASE 
        WHEN item_key = 'double_stars_5_questions' THEN 100
        WHEN item_key = 'triple_stars_5_questions' THEN 180
        WHEN item_key = 'five_times_stars_5_questions' THEN 350
        WHEN item_key = 'double_stars_60_seconds' THEN 120
        WHEN item_key = 'oled_theme' THEN 150
        WHEN item_key = 'green_theme' THEN 120
        WHEN item_key = 'orange_theme' THEN 120
        WHEN item_key = 'ai_theme_generator' THEN 200
        ELSE base_price
    END,
    current_price = CASE 
        WHEN item_key = 'double_stars_5_questions' THEN 100
        WHEN item_key = 'triple_stars_5_questions' THEN 180
        WHEN item_key = 'five_times_stars_5_questions' THEN 350
        WHEN item_key = 'double_stars_60_seconds' THEN 120
        WHEN item_key = 'oled_theme' THEN 150
        WHEN item_key = 'green_theme' THEN 120
        WHEN item_key = 'orange_theme' THEN 120
        WHEN item_key = 'ai_theme_generator' THEN 200
        ELSE current_price
    END
WHERE item_key IN (
    'double_stars_5_questions',
    'triple_stars_5_questions', 
    'five_times_stars_5_questions',
    'double_stars_60_seconds',
    'oled_theme',
    'green_theme',
    'orange_theme',
    'ai_theme_generator'
);

-- Function to automatically update current price based on discount status and dates
CREATE OR REPLACE FUNCTION update_current_price()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if discount is currently active (if discount dates are set)
    IF NEW.discount_start IS NOT NULL AND NEW.discount_end IS NOT NULL THEN
        -- If currently within discount period
        IF NOW() >= NEW.discount_start AND NOW() <= NEW.discount_end THEN
            NEW.is_discounted := TRUE;
            NEW.current_price := NEW.base_price - (NEW.base_price * NEW.discount_percentage / 100);
        ELSE
            -- Outside discount period
            NEW.is_discounted := FALSE;
            NEW.current_price := NEW.base_price;
        END IF;
    ELSIF NEW.discount_percentage > 0 THEN
        -- If discount percentage is set but no dates, apply discount permanently
        NEW.is_discounted := TRUE;
        NEW.current_price := NEW.base_price - (NEW.base_price * NEW.discount_percentage / 100);
    ELSE
        -- No discount
        NEW.is_discounted := FALSE;
        NEW.current_price := NEW.base_price;
    END IF;

    -- Make sure current price is never negative
    NEW.current_price := GREATEST(NEW.current_price, 0);

    NEW.updated_at := NOW();
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update current price before insert or update
CREATE TRIGGER update_current_price_trigger
    BEFORE INSERT OR UPDATE ON store_items
    FOR EACH ROW
    EXECUTE FUNCTION update_current_price();

-- RLS (Row Level Security) setup - optional but recommended for security
ALTER TABLE store_items ENABLE ROW LEVEL SECURITY;

-- Create a policy to allow public read access to active items
CREATE POLICY "Allow public read access to active store items" ON store_items
    FOR SELECT TO authenticated, anon
    USING (is_active = TRUE);