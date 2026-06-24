(require rackunit)

;; =============================================================================
;; ========================== ORIGINAL TESTS ==========================
;; =============================================================================

;; --- Q1 Original Tests ---
(check-equal? (take (sqrt-lzl 2 1) 3) '((1 . 1) (3/2 . 1/4)  (17/12 . 1/144)) "incorrect sqrt-lzl")
(check-equal? (find-first (integers-from 1) (lambda (x) (> x 10))) 11 "incorrect find-first 1")
(check-equal? (find-first (cons-lzl 1 (lambda() (cons-lzl 2 (lambda () '())))) (lambda (x) (> x 10))) 'fail "incorrect find-first 2")
(check-equal? (sqrt2 2 1 0.0001) (+ 1 (/ 169 408)) "incorrect sqrt2")

;; --- Q2 Original Tests ---
(check-equal? (get-value '((a . 3) (b . 4)) 'b)  4 "incorrect get-value 1")
(check-equal? (get-value '((a . 3) (b . 4)) 'c) 'fail "incorrect get-value 2")
(check-equal? (get-value$ '((a . 3) (b . 4)) 'b (lambda(x) (* x x )) (lambda() #f)) 16 "incorrect get-value$ 1")
(check-equal? (get-value$ '((a . 3) (b . 4)) 'c (lambda(x) (* x x)) (lambda() #f)) #f "incorrect get-value$ 2")

(define l1 '((a . 1) (e . 2)))
(define l2 '((e . 5) (f . 6)))
(check-equal? (collect-all-values-1 (list l1 l2) 'e) '(2 5) "incorrect collect-all-values-1 1")
(check-equal? (collect-all-values-1 (list l1 l2) 'k) '() "incorrect collect-all-values-1 2")
(check-equal? (collect-all-values-2 (list l1 l2) 'e) '(2 5) "incorrect collect-all-values-2 1")
(check-equal? (collect-all-values-2 (list l1 l2) 'k) '() "incorrect collect-all-values-2 2") 

;; =============================================================================
;; ===================== טסטים נוספים ומקרי קצה (התוספות שלנו) =====================
;; =============================================================================

;; --- Q1 Extended Tests ---

; חילוץ איבר מתוך רשימה עצלה ריקה לגמרי
(check-equal? (find-first empty-lzl (lambda (x) (> x 0))) 'fail "find-first נכשל על רשימה ריקה לגמרי")

; הניחוש הראשון הוא האיבר שאנחנו מחפשים (לא צריך לחשב זנב)
(check-equal? (find-first (integers-from 5) (lambda (x) (>= x 5))) 5 "find-first נכשל כשהאיבר הראשון מתאים")

; שורש כשהניחוש ההתחלתי הוא התשובה המדויקת (התנאי יתקיים מיד)
(check-equal? (sqrt2 9 3 0.0001) 3 "sqrt2 נכשל כשהניחוש הוא כבר השורש המדויק")

; שורש של שבר (שימוש ב-check-within כדי לא ליפול על הבדלים מיקרוסקופיים בעשרוני)
(check-within (sqrt2 0.25 1 0.0001) 0.5 0.001 "sqrt2 נכשל על שבר קטן מ-1")

; שורש של מספר גדול במיוחד
(check-within (sqrt2 10000 1 0.0001) 100 0.001 "sqrt2 נכשל על מספר גדול")


;; --- Q2 Extended Tests ---

(define ext-empty '())
(define ext-no-key '((a . 1) (b . 2) (c . 3)))
(define ext-with-key '((x . 10) (key . 42) (y . 20)))
(define ext-duplicate-key '((key . 99) (key . 888) (z . 5))) ; מפתח שמופיע פעמיים באותה רשימה!
(define ext-long '((m . 1) (n . 2) (o . 3) (p . 4) (key . 7) (q . 5)))

; --- get-value tests ---
(check-equal? (get-value ext-empty 'key) 'fail "get-value נכשל על רשימה ריקה")
(check-equal? (get-value ext-duplicate-key 'key) 99 "get-value צריך להחזיר רק את המופע הראשון של המפתח")
(check-equal? (get-value ext-long 'key) 7 "get-value לא מצא מפתח שקבור עמוק ברשימה ארוכה")

; --- get-value$ tests ---
(check-equal? (get-value$ ext-empty 'key (lambda (x) (* x 2)) (lambda () 'back-to-safety)) 'back-to-safety 
              "get-value$ לא הפעיל פונקציית כישלון על רשימה ריקה")
(check-equal? (get-value$ ext-duplicate-key 'key (lambda (x) (+ x 1)) (lambda () #f)) 100 
              "get-value$ לא החזיר מופע ראשון או נכשל בהפעלת פונקציית ההצלחה")

; --- collect-all-values tests ---

; רשימה ריקה לגמרי של רשימות
(check-equal? (collect-all-values-1 '() 'key) '() "collect-1 נכשל כשלא מועברות רשימות כלל")
(check-equal? (collect-all-values-2 '() 'key) '() "collect-2 נכשל כשלא מועברות רשימות כלל")

; מועברת רק רשימה אחת בודדת (שמכילה את המפתח)
(check-equal? (collect-all-values-1 (list ext-with-key) 'key) '(42) "collect-1 נכשל כשיש רק רשימה אחת")
(check-equal? (collect-all-values-2 (list ext-with-key) 'key) '(42) "collect-2 נכשל כשיש רק רשימה אחת")

; המפתח לא מופיע באף אחת מהרשימות שהועברו
(check-equal? (collect-all-values-1 (list ext-no-key ext-no-key) 'key) '() "collect-1 לא החזיר רשימה ריקה כשהמפתח לא קיים בכלל")
(check-equal? (collect-all-values-2 (list ext-no-key ext-no-key) 'key) '() "collect-2 לא החזיר רשימה ריקה כשהמפתח לא קיים בכלל")

; מקרה קצה מורכב במיוחד: הכל ביחד! (ריק, חסר, כפולות, וארוך)
(define ext-complex-list (list ext-with-key ext-empty ext-no-key ext-duplicate-key ext-long))
; מצופה שנקבל: 42 (מהראשון), דילוג, דילוג, 99 (רק המופע הראשון מהרביעי!), 7 (מהאחרון)
(check-equal? (collect-all-values-1 ext-complex-list 'key) '(42 99 7) "collect-1 נכשל במקרה משולב וארוך")
(check-equal? (collect-all-values-2 ext-complex-list 'key) '(42 99 7) "collect-2 נכשל במקרה משולב וארוך")

(display "All original and extended tests passed successfully! 🚀🏆\n")