# Taker
---
## API Spec
1. 註冊 `POST /signup.php`  

        傳入：
        {
            "player_id": "player1",
            "password": "Afewaf23rd34fc3"
        }
        回傳：
        {
            "code": 200,
            "data": "ACCEPT"
        }
        
2. 登入 `POST /login.php`

        傳入：
        {
            "player_id": "player1",
            "password": "Afewaf23rd34fc3"
        }
        回傳：
        {
            "code": 200,
            "data": "ACCEPT"
        }

3. 取得玩家資訊 `GET /get_player.php?player_id=kk`

        回傳：
        {
            "code": 200,
            "data": {
                "score":    12,
                "invited":  ["round1", "round2"],
                "updated":  1423040382
            }
        }

4. 取得線上列表 `GET /get_online_list.php`  
    取得最後更新時間 10 秒內的玩家

        回傳：
        {
            "code": 200,
            "data": ["player1", "player2"]
        }

5. 傳送玩家心跳 `POST /heartbeat.php`
    每隔 3 秒傳送玩家心跳

        傳入：
        {
            "player_id": "player1"
        }
        回傳：
        {
            "code": 200,
            "data": "ACCEPT"
        }

6. 建立新賽局   `POST /new_round.php`

        傳入：
        {
            "player1": "player1",
            "player2": "player2"
        }
        回傳：
        {
            "code": 200,
            "data": "round1"
        }

7. 取得賽局資訊 `GET /get_round.php?round_id=round1`

        回傳：
        {
            "code": 200,
            "data": {
                "player1":  "player1",
                "player2":  "player2",
                "score":    10,
                "act":      0,
                "problem":  "Problem1",
                "answer":   "Answer1",
                "options":  ["Problem1", "Problem2", "Problem3"],
                "pictures": ["PictureURL1", "PictureURL2", "PictureURL3"]
            }
        }

8. 接受賽局 `POST /accept_round.php`

        傳入：
        {
            "round_id": "round1"
        }
        回傳：
        {
            "code": 200,
            "data": "ACCEPT"
        }

9. 出下一題 `POST /next_problem.php`

        傳入：
        {
                "round_id": "round1"
        }
        回傳：
        {
            "code": 200,
            "data": "ACCEPT"
        }

10. 傳送圖片    `POST /send_picture.php`

        傳入：
        filename = {prob_id}/{round_id}-{prob_cnt}.png
        回傳：
        {
            "code": 200,
            "data": "ACCEPT"
        }

11. 回答問題    `POST /answer_problem.php`

        傳入：
        {
            "round_id": "round1",
            "answer":   "answer1"
        }
        回傳：
        {
            "code": 200,
            "data": "ACCEPT"
        }

## MySQL Tables
+ round
    + round_id
    + players
    + score
    + act
    + prob_cnt
    + prob_id
    + answer
+ player
    + player_id
    + password
    + updated
+ problem
    + prob_id
    + name
    + class
