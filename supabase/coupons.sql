-- Create coupons table
CREATE TABLE IF NOT EXISTS public.coupons (
    code text NOT NULL PRIMARY KEY,
    reward_type text NOT NULL CHECK (reward_type IN ('stars', 'theme')),
    reward_value text NOT NULL, -- Can be integer (as string) for stars, or ID for others
    expiration_date timestamp with time zone NOT NULL,
    max_uses integer NOT NULL DEFAULT 1,
    current_uses integer NOT NULL DEFAULT 0,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;

-- Create policy to allow read access for authenticated and anon users
CREATE POLICY "Allow read access for all users" ON public.coupons
    FOR SELECT
    TO authenticated, anon
    USING (true);

-- Create policy to allow update access for authenticated and anon users (to increment usage)
CREATE POLICY "Allow update access for all users" ON public.coupons
    FOR UPDATE
    TO authenticated, anon
    USING (true)
    WITH CHECK (true);

-- Insert some sample coupons
INSERT INTO public.coupons (code, reward_type, reward_value, expiration_date, max_uses)
VALUES
    ('WELCOME2026', 'stars', '100', '2026-12-31 23:59:59+00', 1000),
    ('STARTER2026', 'stars', '50', '2026-12-31 23:59:59+00', 1000),
    ('BONUS500', 'stars', '500', '2026-12-31 23:59:59+00', 100),
    ('THEME_GIFT', 'theme', 'christmas', '2026-12-31 23:59:59+00', 50),
    ('THEME_OLED', 'theme', 'oled', '2026-12-31 23:59:59+00', 50),
    ('THEME_GREEN', 'theme', 'green', '2026-12-31 23:59:59+00', 50)
ON CONFLICT (code) DO NOTHING;

-- Function to check if a coupon is valid
CREATE OR REPLACE FUNCTION is_coupon_valid(coupon_code TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    coupon_record coupons%ROWTYPE;
BEGIN
    SET search_path = public, pg_temp;
    SELECT * INTO coupon_record FROM coupons WHERE code = coupon_code;
    
    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;
    
    IF coupon_record.expiration_date < NOW() THEN
        RETURN FALSE;
    END IF;
    
    IF coupon_record.current_uses >= coupon_record.max_uses THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to increment coupon usage
CREATE OR REPLACE FUNCTION increment_coupon_usage(coupon_code TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    coupon_record coupons%ROWTYPE;
BEGIN
    SET search_path = public, pg_temp;
    UPDATE coupons
    SET current_uses = current_uses + 1
    WHERE code = coupon_code
    AND current_uses < max_uses
    AND expiration_date > NOW();
    
    RETURN FOUND;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to redeem a coupon
CREATE OR REPLACE FUNCTION redeem_coupon(coupon_code TEXT, user_id UUID)
RETURNS JSON AS $$
DECLARE
    coupon_record coupons%ROWTYPE;
    result JSON;
BEGIN
    SET search_path = public, pg_temp;
    SELECT * INTO coupon_record FROM coupons WHERE code = coupon_code;
    
    IF NOT FOUND THEN
        result := json_build_object('success', FALSE, 'error', 'Coupon not found');
        RETURN result;
    END IF;
    
    IF coupon_record.expiration_date < NOW() THEN
        result := json_build_object('success', FALSE, 'error', 'Coupon has expired');
        RETURN result;
    END IF;
    
    IF coupon_record.current_uses >= coupon_record.max_uses THEN
        result := json_build_object('success', FALSE, 'error', 'Coupon has reached maximum uses');
        RETURN result;
    END IF;
    
    UPDATE coupons
    SET current_uses = current_uses + 1
    WHERE code = coupon_code;
    
    result := json_build_object(
        'success', TRUE,
        'reward_type', coupon_record.reward_type,
        'reward_value', coupon_record.reward_value
    );
    
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
