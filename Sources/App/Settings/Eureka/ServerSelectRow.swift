import Eureka
import Shared

final class ServerSelectRow: _PushRow<PushSelectorCell<AccountRowValue>>, RowType {
    public required convenience init(tag: String?) {
        self.init(tag: tag, includeAll: false)
    }

    init(tag: String?, includeAll: Bool, _ initializer: (ServerSelectRow) -> Void = { _ in }) {
        super.init(tag: tag)
        title = L10n.Settings.ServerSelect.title
        selectorTitle = L10n.Settings.ServerSelect.title
        displayValueFor = { value in
            if case let .server(server) = value {
                return server.info.name
            } else {
                return value?.placeholderTitle
            }
        }
        optionsProvider = .lazy { _, handler in
            var values = [AccountRowValue]()

            if includeAll {
                values.append(.all)
            }

            values.append(contentsOf: Current.servers.all.map { .server($0) })

            handler(values)
        }
        onPresent { _, to in
            to.enableDeselection = false
        }
        cellUpdate { cell, row in
            if row.isDisabled {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .disclosureIndicator
            }
        }
        initializer(self)
    }
}
