## v0.1.1

* Pin github actions and update versions
* Remove unneeded serviceaccounts resource from readonly role

## v0.1.0

* Initial release with four ClusterRoles: readonly, operator, logs, and debug
* Helm `lookup` function to skip namespace RoleBindings for non-existent namespaces
* Configurable cluster-wide and namespace-scoped role bindings
