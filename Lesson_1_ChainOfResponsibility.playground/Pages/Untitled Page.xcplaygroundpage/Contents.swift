//JustDev
//Swuft 2 Design Patterns Course 
//www.vk.com/JustDev
//www.youtube.com/c/JustDev

//Цепочка обязанностей. Поведенческий шаблон.

//Пример:

class MoneyPile { //Пачка купюр
    let value: Int //Номинал
    var quantity: Int //Количество
    var nextPile: MoneyPile? //Следующая пачка купюр.
    
    init(value: Int, quantity: Int, nextPile: MoneyPile?) {
        self.value = value
        self.quantity = quantity
        self.nextPile = nextPile
    }
    
    func canWithdraw(var v: Int) -> Bool { //Может ли заданная сумма "v" быть выдана?
        
        func canTakeSomeBill(want: Int) -> Bool { //Можно ли выдать купюру конкретного номинала?
            return (want / self.value) > 0 //возвращает "ДА" если желаемая сума, разделенная на номинал текущей пачки больше 0
        }
        
        var q = self.quantity
        
        while canTakeSomeBill(v) {
            
            if q == 0 { //как только купюры в пачке закончились
                break
            }
            
            v -= self.value //мы получили купюру этого номинала, а значит наш запрос должен уменьшиться на эту сумму
            q -= 1 //И данных купюр в пачьке уже меньше
        }
        
        if v == 0 { //Если наш запрос стал 0
            return true //То мы получили деньги
        } else if let next = self.nextPile { //иначе (Как пример - не хватило купюр)
            return next.canWithdraw(v) //запускаем проверку следующей по цепочке пачки
        }
        
        return false
    }
}

class ATM { //Банкомат
    private var hundred: MoneyPile //Номинал 100
    private var fifty: MoneyPile //Номинал 50
    private var twenty: MoneyPile //Номинал 20
    private var ten: MoneyPile //Номинал 10
    
    private var startPile: MoneyPile { //Стартовая пачка
        return self.hundred
    }
    
    init(hundred: MoneyPile,
        fifty: MoneyPile,
        twenty: MoneyPile,
        ten: MoneyPile) {
            
            self.hundred = hundred
            self.fifty = fifty
            self.twenty = twenty
            self.ten = ten
    }
    
    func canWithdraw(value: Int) -> String {
        return "Can withdraw: \(self.startPile.canWithdraw(value))" //можно снять: Да/Нет
    }
}

//Использование

// Создаем пачки денег. Каждая пачка ссылается на пачку меньшего номинала.
let ten = MoneyPile(value: 10, quantity: 6, nextPile: nil)
let twenty = MoneyPile(value: 20, quantity: 2, nextPile: ten)
let fifty = MoneyPile(value: 50, quantity: 2, nextPile: twenty)
let hundred = MoneyPile(value: 100, quantity: 1, nextPile: fifty)

// Создаем банкомат.
var atm = ATM(hundred: hundred, fifty: fifty, twenty: twenty, ten: ten)
atm.canWithdraw(310) // У банкомата есть только 300, так что НЕТ
atm.canWithdraw(100) // Можно выдать - У нас есть 1 стодолларовая купюра
atm.canWithdraw(165) // Нельзя выдать - минимальная купюра в банкомате - 10. Мы никак не сложим из них 165
atm.canWithdraw(30)  // Можно выдать - 1x20, 2x10

