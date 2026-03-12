from datetime import datetime

def success_response(data=None, message="Success"):
    response = {"success": True, "message": message}
    if data is not None:
        response["data"] = data
    return response

def error_response(message="Something went wrong"):
    return {"success": False, "message": message}

def format_phone(phone):
    phone = str(phone).strip()
    if phone.startswith("91") and len(phone) == 12:
        return phone[2:]
    if phone.startswith("+91"):
        return phone[3:]
    return phone

def days_ago(dt):
    if not dt:
        return None
    return (datetime.utcnow() - dt).days

def calculate_freshness_label(last_confirmed):
    if not last_confirmed:
        return "Never confirmed"
    days = (datetime.utcnow() - last_confirmed).days
    if days == 0:
        return "Confirmed today"
    elif days <= 30:
        return f"Confirmed {days} days ago"
    else:
        return f"Last confirmed {days} days ago — may be stale"