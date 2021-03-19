## Rails 進階

1. Gemfile的版本號要標準精確
2. 本地和服務器的環境要完全一致： ruby version, rails version, mysql version
3. 代碼風格： 寧可囉嗦，不要簡寫

4. 優化： 每個column 都要加上index
5. 使用 bullet 減少 n + 1 請求
6. 關鍵的地方多使用logger。
7. 優化數據庫的知識
8. 發起的http 請求，務必要加上timeout , 1~2s以內
9. 要打開數據庫的slow query。這樣數據庫中哪個查詢慢了可以瞬間定位到。
10. 單元測試

