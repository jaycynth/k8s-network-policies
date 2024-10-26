### Policies
By default, Kubernaetes has any to any network policy

## default-deny-user Policy:
- This denies all ingress and egress traffic for endpoints with the label app: user.
- No communication can happen unless explicitly allowed by other policies.
- This type of policy enforces a "zero-trust" model where no communication is permitted by default, minimizing the attack surface

## allow-mysql-to-user Policy:
- This allows only ingress traffic to endpoints with the label app: user from endpoints with the label app: mysql.
- This allows the MySQL service to send responses back to the user app.

## allow-user-to-mysql Policy:
- This allows only egress traffic from endpoints with the label app: user to endpoints with the label app: mysql.
- This enables the user app to send requests to the MySQL service.


### Attack Scenario - Detecting Potential Intrusions

- Use Hubble to trace the source of connections. Check if they come from an unauthorized pod or external IP.

