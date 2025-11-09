import mysql.connector
from mysql.connector import Error

DB_HOST = "localhost"
DB_PORT = 55555
DB_USER = "root"
DB_PASSWORD = ""
DB_DATABASE = "mydb"


def get_connection():
    try:
        connection = mysql.connector.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_DATABASE
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Error connecting to MySQL database: {e}")
        return None
    return None


def create_designation(title):
    connection = get_connection()
    if not connection:
        return

    cursor = connection.cursor()
    try:
        insert_query = "INSERT INTO designation (title) VALUES (%s)"
        cursor.execute(insert_query, (title,))
        connection.commit()
        print(f"\n Record '{title}' inserted successfully.")
    except Error as e:
        print(f"\n Error inserting record: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()


def read_designations():
    connection = get_connection()
    if not connection:
        return

    cursor = connection.cursor()
    try:
        cursor.execute("SELECT code, title FROM designation ORDER BY code ASC")
        rows = cursor.fetchall()

        if not rows:
            print("\n No designation records found in the database.")
            return

        print("\n--- Designation Records ---")
        for row in rows:
            print(f"Code: {row[0]:<4} | Title: {row[1].strip()}")
        print("---------------------------")

    except Error as e:
        print(f"\n Error reading records: {e}")
    finally:
        cursor.close()
        connection.close()


def update_designation(code, new_title):
    connection = get_connection()
    if not connection:
        return

    cursor = connection.cursor()
    try:
        update_query = "UPDATE designation SET title=%s WHERE code=%s"
        cursor.execute(update_query, (new_title, code))
        connection.commit()

        if cursor.rowcount > 0:
            print(f"\n Record with code {code} updated successfully to '{new_title}'.")
        else:
            print(f"\n No record found with code {code}. Nothing updated.")

    except Error as e:
        print(f"\n Error updating record: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()


def delete_designation(code):
    connection = get_connection()
    if not connection:
        return

    cursor = connection.cursor()
    try:
        delete_query = "DELETE FROM designation WHERE code=%s"
        cursor.execute(delete_query, (code,))
        connection.commit()

        if cursor.rowcount > 0:
            print(f"\n Record with code {code} deleted successfully.")
        else:
            print(f"\n No record found with code {code}. Nothing deleted.")

    except Error as e:
        print(f"\n Error deleting record: {e}")
        connection.rollback()
    finally:
        cursor.close()
        connection.close()


def main():
    while True:
        print("\n" + "="*30)
        print("    MySQL Designation Manager")
        print("="*30)
        print("1. Add Designation (Create)")
        print("2. View All Designations (Read)")
        print("3. Update Designation (Update)")
        print("4. Delete Designation (Delete)")
        print("5. Exit")
        print("="*30)

        choice = input("Enter your choice (1-5): ")

        if choice == "1":
            title = input("   Enter new designation title: ")
            if title:
                create_designation(title)
            else:
                print("   Title cannot be empty.")

        elif choice == "2":
            read_designations()

        elif choice == "3":
            try:
                code = int(input("   Enter designation code to update: "))
                new_title = input("   Enter new designation title: ")
                if new_title:
                    update_designation(code, new_title)
                else:
                    print("   New title cannot be empty.")
            except ValueError:
                print("\n   Invalid input. Code must be an integer.")

        elif choice == "4":
            try:
                code = int(input("   Enter designation code to delete: "))
                delete_designation(code)
            except ValueError:
                print("\n   Invalid input. Code must be an integer.")

        elif choice == "5":
            print("\n Exiting the Designation Manager. Goodbye!")
            break

        else:
            print("\n Invalid choice, please enter a number between 1 and 5.")


if __name__ == "__main__":
    main()