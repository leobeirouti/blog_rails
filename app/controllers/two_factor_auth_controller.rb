class TwoFactorAuthController < ApplicationController
  before_action :authenticate_user!

  # Exibir QR Code para configurar o 2FA
  def show_qr
    unless current_user.otp_secret
      current_user.otp_secret = User.generate_otp_secret
      current_user.save!
    end

    qr_code = current_user.otp_provisioning_uri(current_user.email, issuer: "MeuApp")
    render json: { qr_code: qr_code }
  end

  # Confirmar ativação do 2FA (usuário digita o código gerado pelo app autenticador)
  def enable
    if current_user.validate_and_consume_otp!(params[:otp_attempt])
      current_user.otp_required_for_login = true
      current_user.save!
      render json: { message: "Autenticação de dois fatores ativada com sucesso!" }, status: :ok
    else
      render json: { error: "Código inválido. Tente novamente." }, status: :unprocessable_entity
    end
  end

  # Desativar 2FA
  def disable
    if current_user.update(otp_required_for_login: false, otp_secret: nil)
      render json: { message: "Autenticação de dois fatores desativada com sucesso." }, status: :ok
    else
      render json: { error: "Erro ao desativar 2FA." }, status: :unprocessable_entity
    end
  end
end
