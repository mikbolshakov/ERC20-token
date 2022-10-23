// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TinToken.sol";

contract ActivityReward {

    function registrationBonus(address _newUser) public {
        balances[_newUser] += 10;
        thisOwner.balance -= 10;
    }
}

// плата за размещение новой NFT = K * 1TTN

//     Пользователь:
//  r = A1 + A2 + … + An
//  где r - рейтинг NFT, А - активность (коммент, лайк)

//  UR = r1 + r2 + … + rn,
//  где UR - рейтинг пользователя, rn - рейтинг каждой NFT

//  К = 0.0001 * UR,
//  где K - коэффициент пользователя

// Ограничения:
//  В сутки:
//  - получить не более 100 токенов
//  - сделать не более 24 активностей
//  В неделю:
//  - не больше 1 активности к одной и той же NFT

// Стоимость:
//  цена размещения NFT = 1 токен * K
//  цена 1 актиности = (1 токен + r) / 100

// Награды:
//  забрать токены = 0.01 * r
