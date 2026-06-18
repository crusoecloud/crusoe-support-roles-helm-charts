## v0.2.0

* Promote the chart out of alpha
* Add a security policy ([SECURITY.md](SECURITY.md)) with vulnerability reporting instructions
* Add an API Priority and Fairness FlowSchema and PriorityLevelConfiguration that caps concurrent API server requests from the support credential groups
* Add the `slurm` namespace to the privileged namespace list for the logs and debug role bindings, but only for the `operator` group

## v0.1.1

* Pin github actions and update versions
* Remove unneeded serviceaccounts resource from readonly role

## v0.1.0

* Initial release with four ClusterRoles: readonly, operator, logs, and debug
* Helm `lookup` function to skip namespace RoleBindings for non-existent namespaces
* Configurable cluster-wide and namespace-scoped role bindings
