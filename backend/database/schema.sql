-- ─────────────────────────────────────────
-- RaktSetu Database Schema
-- Run this in Supabase SQL Editor
-- ─────────────────────────────────────────

-- 1. DONORS TABLE
CREATE TABLE IF NOT EXISTS donors (
    id                  SERIAL PRIMARY KEY,
    name                VARCHAR(100) NOT NULL,
    phone               VARCHAR(15) UNIQUE NOT NULL,
    blood_group         VARCHAR(5) NOT NULL CHECK (blood_group IN ('A+','A-','B+','B-','O+','O-','AB+','AB-')),
    latitude            DECIMAL(10, 8),
    longitude           DECIMAL(11, 8),
    pincode             VARCHAR(6),
    city                VARCHAR(100),
    is_active           BOOLEAN DEFAULT TRUE,
    last_confirmed      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_donated        TIMESTAMP,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. EMERGENCY REQUESTS TABLE
CREATE TABLE IF NOT EXISTS emergency_requests (
    id                  SERIAL PRIMARY KEY,
    requester_name      VARCHAR(100) NOT NULL,
    requester_phone     VARCHAR(15) NOT NULL,
    blood_group         VARCHAR(5) NOT NULL CHECK (blood_group IN ('A+','A-','B+','B-','O+','O-','AB+','AB-')),
    hospital_name       VARCHAR(200) NOT NULL,
    hospital_address    VARCHAR(300),
    latitude            DECIMAL(10, 8),
    longitude           DECIMAL(11, 8),
    units_needed        INT DEFAULT 1,
    additional_notes    TEXT,
    status              VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'fulfilled', 'expired', 'cancelled')),
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fulfilled_at        TIMESTAMP
);

-- 3. DONOR ALERTS TABLE
CREATE TABLE IF NOT EXISTS donor_alerts (
    id                  SERIAL PRIMARY KEY,
    request_id          INT REFERENCES emergency_requests(id) ON DELETE CASCADE,
    donor_id            INT REFERENCES donors(id) ON DELETE CASCADE,
    alerted_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response            VARCHAR(20) DEFAULT 'pending' CHECK (response IN ('pending', 'accepted', 'declined', 'no_response')),
    responded_at        TIMESTAMP,
    radius_batch        INT DEFAULT 1
);

-- 4. DONATION HISTORY TABLE
CREATE TABLE IF NOT EXISTS donation_history (
    id                  SERIAL PRIMARY KEY,
    donor_id            INT REFERENCES donors(id) ON DELETE CASCADE,
    donated_on          TIMESTAMP NOT NULL,
    hospital            VARCHAR(200),
    request_id          INT REFERENCES emergency_requests(id) ON DELETE SET NULL,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ─────────────────────────────────────────
-- INDEXES for faster queries
-- ─────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_donors_blood_group ON donors(blood_group);
CREATE INDEX IF NOT EXISTS idx_donors_is_active ON donors(is_active);
CREATE INDEX IF NOT EXISTS idx_donors_phone ON donors(phone);
CREATE INDEX IF NOT EXISTS idx_requests_status ON emergency_requests(status);
CREATE INDEX IF NOT EXISTS idx_requests_blood_group ON emergency_requests(blood_group);
CREATE INDEX IF NOT EXISTS idx_alerts_request_id ON donor_alerts(request_id);
CREATE INDEX IF NOT EXISTS idx_alerts_donor_id ON donor_alerts(donor_id);