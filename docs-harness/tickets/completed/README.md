# Completed Tickets

This folder stores ticket history after User-authorized completion.

Completed tickets are not part of the default `$ticket-solving` context. Read a
completed ticket only when the User names it, asks for historical context, or
the current ticket has an explicit dependency on it.

The folder location is the lifecycle authority. If a ticket under this folder
still declares `status: active`, normalize the record to
`status: completed`, preserve the decision history, and report the
normalization.
