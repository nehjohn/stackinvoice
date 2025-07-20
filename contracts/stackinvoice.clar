;; StackInvoice - On-Chain Invoicing & Payment System

(define-data-var invoice-counter uint u0)

(define-map invoices
  { id: uint }
  {
    provider: principal,
    client: principal,
    amount: uint,
    description: (buff 100),
    due-block: uint,
    paid: bool,
    withdrawn: bool
  })

;; Create a new invoice
(define-public (create-invoice (client principal) (amount uint) (description (buff 100)) (due-block uint))
  (let ((invoice-id (var-get invoice-counter)))
    (begin
      (var-set invoice-counter (+ invoice-id u1))
      (map-set invoices { id: invoice-id }
        {
          provider: tx-sender,
          client: client,
          amount: amount,
          description: description,
          due-block: due-block,
          paid: false,
          withdrawn: false
        })
      (ok invoice-id))))

;; Client pays invoice
(define-public (pay-invoice (invoice-id uint))
  (let ((inv (unwrap! (map-get? invoices { id: invoice-id }) (err u100))))
    (begin
      (asserts! (is-eq tx-sender (get client inv)) (err u101))
      (asserts! (is-eq (get paid inv) false) (err u102))
      (try! (stx-transfer? (get amount inv) tx-sender (as-contract tx-sender)))

      ;; Mark as paid
      (map-set invoices { id: invoice-id }
        (merge inv { paid: true }))

      (ok true))))

;; Provider withdraws after invoice is paid
(define-public (withdraw-payment (invoice-id uint))
  (let ((inv (unwrap! (map-get? invoices { id: invoice-id }) (err u104))))
    (begin
      (asserts! (is-eq tx-sender (get provider inv)) (err u105))
      (asserts! (is-eq (get paid inv) true) (err u106))
      (asserts! (is-eq (get withdrawn inv) false) (err u107))

      ;; Transfer payment
      (try! (stx-transfer? (get amount inv) (as-contract tx-sender) tx-sender))

      ;; Mark as withdrawn
      (map-set invoices { id: invoice-id }
        (merge inv { withdrawn: true }))

      (ok true))))

;; Read-only: View invoice details
(define-read-only (get-invoice (invoice-id uint))
  (map-get? invoices { id: invoice-id }))
