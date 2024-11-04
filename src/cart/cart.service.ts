import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cart } from 'src/entities/cart.entity';
import { CartDetail } from 'src/entities/cart-detail.entity';
import { Product } from '../entities/product.entity';
import { User } from '../entities/user.entity';
import { AddProductToCartDto } from './dtos/add-product-to-cart.dto';
import { ChangeQuantityDto } from './dtos/change-quantity.dto';

@Injectable()
export class CartService {
  constructor(
    @InjectRepository(Cart) private cartRepo: Repository<Cart>,
    @InjectRepository(CartDetail)
    private cartDetailRepo: Repository<CartDetail>,
    @InjectRepository(Product) private productRepo: Repository<Product>,
  ) {}

  async getCartById(cartId: number) {
    try {
      return await this.cartRepo.findOne({
        where: { id: cartId },
        relations: ['cartDetails'],
      });
    } catch (error) {
      throw new Error('Failed to get cart by id');
    }
  }

  async getCart(user: User) {
    try {
      return await this.cartRepo.findOne({
        where: { user: { id: user.id } },
        relations: ['cartDetails', 'cartDetails.product'],
      });
    } catch (error) {
      throw new Error('Failed to get cart');
    }
  }

  async createCart(user: User) {
    try {
      const cart = this.cartRepo.create({ user });
      return await this.cartRepo.save(cart);
    } catch (error) {
      throw new Error('Failed to create cart');
    }
  }

  async addProductToCart(
    addProductToCartDto: AddProductToCartDto,
    currentUser?: User,
  ) {
    try {
      let cart = await this.cartRepo.findOneBy({
        id: addProductToCartDto.cartId,
      });

      if (!cart && currentUser) {
        cart = await this.createCart(currentUser);
      }

      const product = await this.productRepo.findOneBy({
        id: addProductToCartDto.productId,
      });

      if (!cart || !product) {
        throw new Error('Cart or Product not found');
      }

      const cartDetail = this.cartDetailRepo.create({
        cart,
        product,
        quantity: addProductToCartDto.quantity,
      });

      return await this.cartDetailRepo.save(cartDetail);
    } catch (error) {
      throw new Error('Failed to add product to cart');
    }
  }

  async changeQuantity(changeQuantityDto: ChangeQuantityDto) {
    try {
      const cartDetail = await this.cartDetailRepo.findOne({
        where: { id: changeQuantityDto.cartDetailId },
        relations: ['product'],
      });

      if (!cartDetail) {
        throw new Error('CartDetail not found');
      }

      cartDetail.quantity = changeQuantityDto.quantity;

      if (cartDetail.quantity < 0) {
        cartDetail.quantity = 0;
      }

      return await this.cartDetailRepo.save(cartDetail);
    } catch (error) {
      throw new Error('Failed to change quantity');
    }
  }

  async getCartDetails(user: User) {
    try {
      return await this.cartDetailRepo.find({
        where: { cart: { user: { id: user.id } } },
        relations: ['product'],
      });
    } catch (error) {
      throw new Error('Failed to get cart details');
    }
  }

  async removeProductFromCart(cartDetailId: number) {
    try {
      await this.cartDetailRepo.delete(cartDetailId);
      return { message: 'Product removed from cart' };
    } catch (error) {
      throw new Error('Failed to remove product from cart');
    }
  }

  async clearCart(cartId: number) {
    try {
      const cart = await this.cartRepo.findOne({
        where: { id: cartId },
        relations: ['cartDetails'],
      });

      if (!cart) {
        throw new Error('Cart not found');
      }

      await this.cartDetailRepo.remove(cart.cartDetails);
      return { message: 'Cart cleared' };
    } catch (error) {
      throw new Error('Failed to clear cart');
    }
  }
}
