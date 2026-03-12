import re

VALID_BLOOD_GROUPS = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']

def validate_phone(phone):
    """Validate Indian mobile number — 10 digits"""
    phone = str(phone).strip()
    if re.match(r'^[6-9]\d{9}$', phone):
        return True, phone
    return False, "Invalid phone number. Must be 10 digits starting with 6-9"

def validate_blood_group(blood_group):
    """Validate blood group"""
    blood_group = str(blood_group).strip().upper()
    if blood_group in VALID_BLOOD_GROUPS:
        return True, blood_group
    return False, f"Invalid blood group. Must be one of {VALID_BLOOD_GROUPS}"

def validate_pincode(pincode):
    """Validate Indian PIN code — 6 digits"""
    pincode = str(pincode).strip()
    if re.match(r'^\d{6}$', pincode):
        return True, pincode
    return False, "Invalid PIN code. Must be 6 digits"

def validate_donor_data(data):
    """Validate all donor registration fields"""
    errors = []

    # Name
    if not data.get("name") or len(data["name"].strip()) < 2:
        errors.append("Name must be at least 2 characters")

    # Phone
    phone_valid, phone_msg = validate_phone(data.get("phone", ""))
    if not phone_valid:
        errors.append(phone_msg)

    # Blood group
    bg_valid, bg_msg = validate_blood_group(data.get("blood_group", ""))
    if not bg_valid:
        errors.append(bg_msg)

    # Pincode
    pin_valid, pin_msg = validate_pincode(data.get("pincode", ""))
    if not pin_valid:
        errors.append(pin_msg)

    return errors

def validate_request_data(data):
    """Validate emergency request fields"""
    errors = []

    if not data.get("requester_name") or len(data["requester_name"].strip()) < 2:
        errors.append("Requester name is required")

    phone_valid, phone_msg = validate_phone(data.get("requester_phone", ""))
    if not phone_valid:
        errors.append(phone_msg)

    bg_valid, bg_msg = validate_blood_group(data.get("blood_group", ""))
    if not bg_valid:
        errors.append(bg_msg)

    if not data.get("hospital_name") or len(data["hospital_name"].strip()) < 3:
        errors.append("Hospital name is required")

    return errors