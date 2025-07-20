StackInvoice is a decentralized smart contract on the Stacks blockchain designed for creating, managing, and settling invoices in a secure and transparent manner. It enables service providers, freelancers, and businesses to issue on-chain invoices and receive STX payments directly.

Features
 Create Invoices: Generate invoices with unique identifiers, specifying the recipient, amount, and due date.

 Pay Invoices: Clients can pay invoices in STX directly on-chain.

 Track Payments: Automatically updates the payment status of invoices.

 Query Invoices: Retrieve invoice details and check payment status via read-only functions.

Functions
Public Functions
create-invoice (invoice-id uint) (recipient principal) (amount uint) (due-block uint)

Creates a new invoice with specified details.

pay-invoice (invoice-id uint)

Pays the specified invoice if it is active and unpaid.

Read-Only Functions
get-invoice (invoice-id uint)

Returns the details of a specific invoice.

is-paid (invoice-id uint)

Returns true if the invoice has been paid, otherwise false.

Usage example
;; Create an invoice
(create-invoice u1 'SP123...XYZ u1000000 u500)

;; Pay the invoice
(pay-invoice u1)

;; Check payment status
(is-paid u1)

Deployment
Deploy this contract to your Stacks blockchain environment using Clarinet or directly via your preferred deployment tool.

Future Enhancements
Invoice cancellation and refund capability.

SIP-010 token support for multi-currency payments.

Emitting events for creation, payment, and cancellation actions.
