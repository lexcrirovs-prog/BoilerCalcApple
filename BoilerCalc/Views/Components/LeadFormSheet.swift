import SwiftUI

struct LeadFormSheet: View {
    let title: String
    let context: String
    let onDismiss: () -> Void

    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var region: String = ""
    @State private var isSubmitting = false
    @State private var error: String?
    @State private var isSuccess = false

    @Environment(\.themeColors) var colors

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Контактные данные")) {
                    TextField("Ваше имя", text: $name)
                        .disabled(isSubmitting)
                    TextField("Телефон", text: $phone)
                        .keyboardType(.phonePad)
                        .disabled(isSubmitting)
                    TextField("Город / регион", text: $region)
                        .disabled(isSubmitting)
                }

                if let error = error {
                    Section {
                        Text(error)
                            .foregroundColor(colors.error)
                    }
                }

                if isSuccess {
                    Section {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Заявка отправлена!")
                        }
                    }
                }

                Section {
                    Button(action: submit) {
                        if isSubmitting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Отправить")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(name.isEmpty || phone.isEmpty || isSubmitting)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { onDismiss() }
                        .disabled(isSubmitting)
                }
            }
        }
    }

    private func submit() {
        isSubmitting = true
        error = nil

        let data = LeadFormData(
            name: name,
            phone: phone,
            region: region,
            context: context,
            timestamp: ISO8601DateFormatter().string(from: Date())
        )

        Task {
            do {
                try await LeadApiService.submitLead(data)
                await MainActor.run {
                    isSubmitting = false
                    isSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        onDismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    self.error = "Ошибка отправки: \(error.localizedDescription)"
                }
            }
        }
    }
}
