from prettytable import PrettyTable
import psycopg2
    
"""если ввод из консоли данных"""
def annuitent_plat(s, r, n):
    """ годовая ставка / 12 мес. / 100%"""
    r = r/12/100 

    """ежемесячный платёж"""
    p = s*r*(1+r)**n/((1+r)**n - 1)


    table = PrettyTable()
    table.field_names = ["Месяц", 'Ежемесячный платёж', 'Основной долг', 'Долг по процентам', "Остаток основного долга"]
    for i in range(n):
        """процент"""
        persent = s*r

        """долг"""
        debt = p - persent

        """основной долг"""
        s = s - debt

        table.add_row([i+1, round(p, 2), round(debt, 2), round(persent, 2), abs(round(s, 2))])
    print(table)

def bd_data(id):
    with open('D:/тестовое задание/bd_connect.txt') as file:
        user, password, host, port, database = file.readline().strip().split()
    try:
        connection = psycopg2.connect(user=user,
                                  password=password,
                                  host=host,
                                  port=port,
                                  database=database)
        
        cursor = connection.cursor()

        cursor.execute(f'SELECT * FROM Parameters_application_form where id_param_app_form={id}')
        data = cursor.fetchall()

        """ставка"""
        r = float(data[0][3])

        """сумма"""
        s = float(data[0][4])

        """срок в месяцах"""
        n = int(data[0][5])

    except:
        print('Can`t establish connection to database\n')

    finally:
        if connection:
            cursor.close()
            connection.close()
            print("Соединение с PostgreSQL закрыто\n")
            return (s, r, n)

if __name__ == '__main__':
    if int(input('Введите 1, если расчёт графика аннуитетных платежей с данными из консоли\n 2, если с данными из базы данных: ')) == 1:
        s = float(input("Сумма кредита: "))
        r = float(input("Ставка: "))
        n = int(input("Срок (в месяцах): "))
        print(f'Сумма кредита: {s} руб. \nСтавка: {r}% \nСрок: {n} месяцев\n')
    else:
        id = int(input('Введите id заявки для расчёта: '))
        data = bd_data(id)
        s, r, n = data[0], data[1], data[2]

        print(f'ID заявки: {id}\nСумма кредита: {s} руб. \nСтавка: {r}% \nСрок: {n} месяцев\n')
    
   
    annuitent_plat(s,r,n)